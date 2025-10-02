#!/usr/bin/env bash
set -euo pipefail

# Minimal fast loader
# Usage: loadimages.sh [path] [image]
# - path: file or directory with .tar/.tgz files (default: ~/Desktop/update)
# - image: image name to run after load (default: hello-eclipse:latest)

if [ -n "${SUDO_USER:-}" ]; then
  # If run under sudo, prefer the invoking user's Desktop
  DEFAULT_DIR="/home/${SUDO_USER}/Desktop/update"
else
  DEFAULT_DIR="$HOME/Desktop/update"
fi
TARGET="${1:-$DEFAULT_DIR}"
IMAGE="${2:-hello-eclipse:latest}"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker not found in PATH" >&2
  exit 2
fi

## Quick access test: run `docker ps -a` and capture stderr to determine cause.
DOCKER_PS_ERR=$(mktemp)
if ! docker ps -a 2>"$DOCKER_PS_ERR" >/dev/null; then
  DOCKER_ERR_TEXT=$(tr -d '\n' <"$DOCKER_PS_ERR" || true)
  rm -f "$DOCKER_PS_ERR"

  # If user already retried, or docker error is not a permission issue, show full error and exit
  if [ -n "${RETRIED_DOCKER_GROUP:-}" ]; then
    echo "Docker access still failing: $DOCKER_ERR_TEXT" >&2
    exit 1
  fi

  # Only attempt a newgrp retry when the docker error indicates permission denied on the socket
  if echo "$DOCKER_ERR_TEXT" | grep -qi "permission denied\|connect: permission denied\|permission denied while trying to connect"; then
    INVOKER="${SUDO_USER:-$(whoami)}"
    if getent group docker | grep -qw "$INVOKER"; then
      echo "Docker socket access denied — re-running under 'docker' group so you don't need to logout/login..."
      export RETRIED_DOCKER_GROUP=1
      # If script was started via sudo (we're root), re-run as the original user so file paths like ~/Desktop work
      if [ -n "${SUDO_USER:-}" ] && [ "$(id -u)" -eq 0 ]; then
        exec su - "$SUDO_USER" -c "newgrp docker -c 'RETRIED_DOCKER_GROUP=1 bash \"$0\" \"$@\"'"
      else
        exec newgrp docker -c "RETRIED_DOCKER_GROUP=1 bash \"$0\" \"$@\""
      fi
    else
      echo "Docker access denied and user '$INVOKER' is not in 'docker' group." >&2
      echo "To allow non-root docker use: sudo usermod -aG docker $INVOKER; then logout/login or run 'newgrp docker' in your shell." >&2
      exit 1
    fi
  else
    echo "Docker reported an error: $DOCKER_ERR_TEXT" >&2
    exit 1
  fi
fi

# Stop any existing container for the target image before loading new images
PREV_NAME="${IMAGE%%[:/]*}-run"
if docker ps -a --format '{{.Names}}' | grep -x -- "$PREV_NAME" >/dev/null 2>&1; then
  echo "Stopping and removing existing container: $PREV_NAME"
  docker rm -f "$PREV_NAME" >/dev/null 2>&1 || true
fi

# If docker exists but we can't access the daemon because of socket permissions,
# and the user is already listed in the 'docker' group, re-run the script under
# newgrp so the group membership takes effect without requiring a logout/login.
if ! docker info >/dev/null 2>&1; then
  if [ -S /var/run/docker.sock ]; then
    # If socket exists and user is in docker group, try newgrp
    if getent group docker >/dev/null 2>&1 && getent group docker | grep -qw "$(whoami)"; then
      echo "Docker socket access denied — re-running under 'docker' group so you don't need to logout/login..."
      exec newgrp docker -c "bash \"$0\" \"$@\""
    fi
  fi
  echo "Cannot access the Docker daemon. Either run this script with sudo or add your user to the 'docker' group and re-login." >&2
  exit 1
fi

if [ ! -e "$TARGET" ]; then
  echo "Target '$TARGET' does not exist" >&2
  exit 1
fi

TAR_FILES=()
if [ -d "$TARGET" ]; then
  while IFS= read -r -d $'\0' f; do TAR_FILES+=("$f"); done < <(find "$TARGET" -maxdepth 1 -type f \( -name '*.tar' -o -name '*.tar.gz' -o -name '*.tgz' \) -print0)
elif [ -f "$TARGET" ]; then
  TAR_FILES+=("$TARGET")
fi

if [ ${#TAR_FILES[@]} -eq 0 ]; then
  echo "No .tar/.tgz files found in '$TARGET'"
  exit 0
fi

echo "Found ${#TAR_FILES[@]} file(s) to load in $TARGET"
for f in "${TAR_FILES[@]}"; do
  echo "Loading: $f"
  docker load -i "$f"
  echo "Loaded: $f"
done

echo "Starting container from image: $IMAGE"
CONTAINER_NAME="${IMAGE%%[:/]*}-run"
if docker ps -a --format '{{.Names}}' | grep -x -- "$CONTAINER_NAME" >/dev/null 2>&1; then
  echo "Removing existing container: $CONTAINER_NAME"
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
fi

CID=$(docker run -d --name "$CONTAINER_NAME" "$IMAGE")
if [ -z "$CID" ]; then
  echo "Failed to start container" >&2
  exit 1
fi

echo "Started container: $CID"
echo "To follow logs: docker logs -f $CID"

# Try to open logs in a new terminal window. Tries several common terminal emulators.
open_logs_in_terminal() {
  local cid="$1"
  local cmd="docker logs -f $cid"
  # If we are in a TTY-only environment, prefer tmux/screen instead of GUI terminals
  if [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
    if command -v tmux >/dev/null 2>&1; then
      tmux new -d -s loadlogs "${cmd}"
      echo "Started tmux session 'loadlogs' (attach with: tmux attach -t loadlogs)"
      return 0
    elif command -v screen >/dev/null 2>&1; then
      screen -S loadlogs -dm bash -c "${cmd}"
      echo "Started screen session 'loadlogs' (attach with: screen -r loadlogs)"
      return 0
    fi
  fi
  if command -v gnome-terminal >/dev/null 2>&1; then
    gnome-terminal -- bash -lc "$cmd || sudo $cmd; exec bash" &
    return 0
  elif command -v x-terminal-emulator >/dev/null 2>&1; then
    x-terminal-emulator -e bash -lc "$cmd || sudo $cmd; exec bash" &
    return 0
  elif command -v xterm >/dev/null 2>&1; then
    xterm -e bash -lc "$cmd || sudo $cmd; exec bash" &
    return 0
  elif command -v konsole >/dev/null 2>&1; then
    konsole -e bash -lc "$cmd || sudo $cmd; exec bash" &
    return 0
  elif command -v kitty >/dev/null 2>&1; then
    kitty bash -lc "$cmd || sudo $cmd; exec bash" &
    return 0
  elif command -v alacritty >/dev/null 2>&1; then
    alacritty -e bash -lc "$cmd || sudo $cmd; exec bash" &
    return 0
  else
    return 1
  fi
}

# attempt to open logs; ignore failures
if open_logs_in_terminal "$CID"; then
  echo "Opened logs in a new terminal"
else
  echo "No GUI terminal found; run: docker logs -f $CID"
fi