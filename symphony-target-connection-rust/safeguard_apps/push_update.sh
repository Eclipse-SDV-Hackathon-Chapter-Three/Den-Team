#!/usr/bin/env bash
set -euo pipefail

# push_update.sh
# Simplified uploader that sends a .tar file from a local update folder to a
# predefined remote host using password-based SSH (sshpass) if available.
# It uploads to a temporary file, verifies SHA256, and atomically moves the file
# into the final destination. Prints a success message on completion.

### Configuration (edit if needed) ###
HOST=10.191.77.99
USER=mkharde
PORT=22
# Password provided by user
PASS='159357'

# Local folder where the file to send is located
SRC_DIR="/usr/local/bin"
# Default filename inside SRC_DIR
DEFAULT_FILE="images_arm64.tar"

# Remote destination path to place the file
DEST="/home/mkharde/Desktop/update/images_arm64.tar"
######################################

FILE=${1:-$DEFAULT_FILE}
SRC_PATH="$SRC_DIR/$FILE"

if [ ! -f "$SRC_PATH" ]; then
  echo "Error: source file not found: $SRC_PATH" >&2
  exit 2
fi

TMP_REMOTE="${DEST}.tmp.$$"

echo "Using host: $USER@$HOST:$DEST"
echo "Uploading local: $SRC_PATH"

# Attempt non-blocking SSH key installation so future runs don't require password.
# Strategy:
# 1) Test if key-based auth already works (BatchMode). If yes, continue.
# 2) If not, and a local public key exists and sshpass + PASS are available, use
#    sshpass to copy the key non-interactively.
# 3) Otherwise, print a helpful message and continue (do not block).

echo "Checking for key-based SSH access..."
KEY_OK=false
if ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -p "$PORT" "$USER@$HOST" 'echo OK' >/dev/null 2>&1; then
  KEY_OK=true
  echo "Key-based SSH already works."
else
  echo "Key-based SSH not available. Will try to install public key if possible (non-blocking)."
  PUBKEY_FILE=""
  if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    PUBKEY_FILE="$HOME/.ssh/id_ed25519.pub"
  elif [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    PUBKEY_FILE="$HOME/.ssh/id_rsa.pub"
  fi

  if [ -n "$PUBKEY_FILE" ] && command -v sshpass >/dev/null 2>&1 && [ -n "${PASS:-}" ]; then
    echo "Found local pubkey ($PUBKEY_FILE) and sshpass; attempting non-interactive install of key..."
    set +e
    sshpass -p "$PASS" ssh -o StrictHostKeyChecking=accept-new -p "$PORT" "$USER@$HOST" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys" < "$PUBKEY_FILE" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "Public key installed on remote host."
      # verify
      if ssh -o BatchMode=yes -o ConnectTimeout=5 -p "$PORT" "$USER@$HOST" 'echo OK' >/dev/null 2>&1; then
        KEY_OK=true
      fi
    else
      echo "Non-interactive key install failed (sshpass). Continuing without blocking."
    fi
    set -e
  else
    if [ -z "$PUBKEY_FILE" ]; then
      echo "No local public key found (~/.ssh/id_ed25519.pub or id_rsa.pub)."
    elif ! command -v sshpass >/dev/null 2>&1; then
      echo "sshpass not available — cannot install key non-interactively."
    elif [ -z "${PASS:-}" ]; then
      echo "No password available to install key non-interactively."
    fi
    echo "Continuing; you may be prompted for the password during upload."
  fi
fi

use_sshpass=false
if command -v sshpass >/dev/null 2>&1; then
  use_sshpass=true
fi

echo "Computing local SHA256..."
LOCAL_SHA=$(sha256sum "$SRC_PATH" | awk '{print $1}')
echo "Local SHA256: $LOCAL_SHA"

if [ "$use_sshpass" = true ] && [ "$KEY_OK" = false ]; then
  echo "sshpass found — using password authentication for upload"
  sshpass -p "$PASS" scp -o StrictHostKeyChecking=accept-new -P "$PORT" "$SRC_PATH" "$USER@$HOST:$TMP_REMOTE"
  REMOTE_SHA=$(sshpass -p "$PASS" ssh -o StrictHostKeyChecking=accept-new -p "$PORT" "$USER@$HOST" "sha256sum '$TMP_REMOTE' 2>/dev/null || true" | awk '{print $1}')
else
  echo "Using SSH (key-based if available) to upload"
  scp -P "$PORT" "$SRC_PATH" "$USER@$HOST:$TMP_REMOTE"
  REMOTE_SHA=$(ssh -p "$PORT" "$USER@$HOST" "sha256sum '$TMP_REMOTE' 2>/dev/null || true" | awk '{print $1}')
fi

if [ -z "$REMOTE_SHA" ]; then
  echo "Error: failed to compute remote checksum or remote file missing" >&2
  if [ "$use_sshpass" = true ]; then
    sshpass -p "$PASS" ssh -p "$PORT" "$USER@$HOST" "rm -f '$TMP_REMOTE' || true" || true
  else
    ssh -p "$PORT" "$USER@$HOST" "rm -f '$TMP_REMOTE' || true" || true
  fi
  exit 3
fi

echo "Remote SHA256: $REMOTE_SHA"

if [ "$LOCAL_SHA" != "$REMOTE_SHA" ]; then
  echo "Error: checksum mismatch (local != remote). Aborting and cleaning up." >&2
  if [ "$use_sshpass" = true ]; then
    sshpass -p "$PASS" ssh -p "$PORT" "$USER@$HOST" "rm -f '$TMP_REMOTE' || true" || true
  else
    ssh -p "$PORT" "$USER@$HOST" "rm -f '$TMP_REMOTE' || true" || true
  fi
  exit 4
fi

echo "Checksums match. Moving remote temp into place..."
if [ "$use_sshpass" = true ]; then
  sshpass -p "$PASS" ssh -p "$PORT" "$USER@$HOST" "mkdir -p \$(dirname '$DEST') && mv -f '$TMP_REMOTE' '$DEST' && echo 'SUCCESS: $DEST updated'"
else
  ssh -p "$PORT" "$USER@$HOST" "mkdir -p \$(dirname '$DEST') && mv -f '$TMP_REMOTE' '$DEST' && echo 'SUCCESS: $DEST updated'"
fi

echo "Upload complete. SUCCESS: $USER@$HOST:$DEST"

sshpass -p "$PASS" ssh mkharde@10.191.77.99 'bash -lc "/home/mkharde/Desktop/loadimages.sh"'
