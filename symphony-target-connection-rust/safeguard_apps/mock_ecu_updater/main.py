import logging
import argparse
from deployment_state import DeploymentState

def main():
    # logging.basicConfig(level=logging.INFO)
    # parser = argparse.ArgumentParser(description="ECU Updater Service")
    # parser.add_argument("--authority", default="ecu-updater.app")
    # parser.add_argument("--uentity_id", default="0x0000A100")
    # parser.add_argument("--uentity_version", default="0x01")
    # parser.add_argument("--command", choices=["zenoh", "mqtt5"], default="zenoh")
    # args = parser.parse_args()

    # # Simulate transport selection
    # if args.command == "zenoh":
    #     logging.info("Using default Zenoh transport")
    # else:
    #     logging.info("Using MQTT 5 transport")

    deployment_state = DeploymentState()

    # # Simulate registering endpoints
    # logging.info("ECU Updater service is up and running")
    # logging.info("GET    method URI: ...")
    # logging.info("UPDATE method URI: ...")
    # logging.info("DELETE method URI: ...")

    deployment_state.test_update()

    try:
        while True:
            pass  # Simulate running service
    except KeyboardInterrupt:
        logging.info("Received SIGTERM, shutting down ...")


if __name__ == "__main__":
    main()