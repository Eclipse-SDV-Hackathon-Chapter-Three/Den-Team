import time
import json
import random


def generate_mock_update_result():
    succeeded = random.choice([True, False])
    result = {
        "UpdateTime": time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),
        "Success": succeeded,
        "Failure": not succeeded,
        "DataSize": random.randint(100, 5000),  # in MB
        "Safe": True if succeeded else random.choice([True, False]),
        "NumRetries": random.randint(0, 5),
        "ReasonOfFailure": ""
    }
    if not succeeded:
        reason = random.choice(["Infotainment is on", "Vehicle not parked", "Driver did not approve", "Unknown error"])
        result["ReasonOfFailure"] = reason
    return result


def main():
    # First result: random success/failure
    first_result = generate_mock_update_result()
    # Second result: always failure, infotainment on
    second_result = {
        "UpdateTime": time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),
        "Success": False,
        "Failure": True,
        "DataSize": random.randint(100, 5000),
        "Safe": random.choice([True, False]),
        "NumRetries": random.randint(0, 5),
        "ReasonOfFailure": "Infotainment is on"
    }
    # Third result: always failure, driver did not approve
    third_result = {
        "UpdateTime": time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),
        "Success": False,
        "Failure": True,
        "DataSize": random.randint(100, 5000),
        "Safe": random.choice([True, False]),
        "NumRetries": random.randint(0, 5),
        "ReasonOfFailure": "Driver did not approve"
    }
    mock_data = [first_result, second_result, third_result]
    with open("approval_consent/mock_update_result.json", "w") as f:
        json.dump(mock_data, f, indent=2)
    print("Mock update results written to approval_consent/mock_update_result.json")

if __name__ == "__main__":
    main()
