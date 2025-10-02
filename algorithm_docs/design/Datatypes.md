# Data type definition
## Stastics information
### Monitoring information (Vehicle Monitor)
- Array: VehicleHistory (ordered)
    - int: Timestamp
    - bool: Ignition
    - bool: Parking
    - bool: Infotainment

### History information (ECU Updater)
- int: RolloutId
- long: DataSize
- Array: StepHistory (ordered)
    - enum: UpdateStep
    - int: Timestamp
    - enum: ErrorCode
    - int: Update duration
    - int: Numbers of retry


### UpdateStep enum
0. Idle: No rollout is being processed
1. Downloading: Downloading data from server and transfer to the target ECU
2. Installing: Installing software by processing downloaded data
3. RollingBack: RollingBack instalation and go back to idle state

### ErrorCode enum
0. Success
1. UpdateNotAllowed
2. CommunicationLost
3. InvalidMetadata
4. Timeout