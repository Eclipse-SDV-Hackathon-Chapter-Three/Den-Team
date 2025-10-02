
import time
import os
import json

# Vehicle history array
VehicleHistory = []

# Function to generate a vehicle state record
def generate_vehicle_state(ignition, parking, infotainment):
    return {
        "Timestamp": int(time.time()),
        "Ignition": ignition,
        "Parking": parking,
        "Infotainment": infotainment
    }

# Function to write vehicle history to a JSON file in a folder
def write_history_to_file(folder="vehicle_history", filename="vehicle_history.json"):
    os.makedirs(folder, exist_ok=True)
    filepath = os.path.join(folder, filename)
    with open(filepath, "w") as f:
        json.dump(VehicleHistory, f, indent=2)


# Function to get the vehicle history (for ECU Updater or other modules)
def get_vehicle_history():
    return VehicleHistory


# Example usage: generate vehicle history when triggered
def main():
    # Simulate some vehicle states
    VehicleHistory.append(generate_vehicle_state(True, False, True))
    print("Vehicle history generated.")
    print(get_vehicle_history())

    write_history_to_file()
    print("Vehicle history written to vehicle_history/vehicle_history.json.")

if __name__ == "__main__":
    main()
