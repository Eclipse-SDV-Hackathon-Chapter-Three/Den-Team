# 1. Your Team at a Glance

## Team Name / Tagline
Den-Team

## Team Members
| Name             | GitHub Handle | Roles |
|------------------|----------|---------------------------------------------|
| Rihab Saidi      | RiSaidi  | Cloud Orchestration, Backend                |
| Priyanka Mohanta | primohanta | In-Vehicle Orchestration, Testing         | 
| Ayane Makiuchi   | upi5         | UX / Dashboard Gamification|
| Mandar kharde    |  mkhardedenso               | Networking & uProtocol Setup|
| satoshi kaneko   | satoshi58                   |  HPC/ECU Integration|


## Challenge
Update Possible Challenge

## Core Idea
### Our Solution
SafeGuard: Your OTA Protector
"Safe, Trusted, and Transparent OTA Updates"

### Problem/Story
OTA updates are essential for vehicle ECUs (battery, motor, HPC). However:
* Blind updates risk vehicle downtime
* Interdependent ECUs may fail if updated in the wrong order
* Drivers may experience disruptions
* OEMs lack a structured history of all updates per vehicle

### SafeGuard Solution
1. Driver Approval -  Updates only occur with driver consent via dashboard/app, avoiding disruption.
2. Dependency Check - ECU updates respect correct order (HPC → Battery → Motor ECU), preventing failures.
3. Vehicle State Condition - Updates only execute if vehicle is stationary, battery safe, and critical ECUs idle.
4. Update Tracker - Tracks all updates over the lifetime of a vehicle. Provides OEMs with historical data for predictive maintenance, analytics, and future development.

Business Value:
* Safety & Reliability: Prevents failed updates and protects vehicle ECUs
* Driver Trust: Approvals + state checks → drivers confident in updates
* Operational Insight: Tracker enables data-driven decisions for OEMs
* Cost Efficiency: Reduces downtime and costly rollbacks
* Future Development: Historical update data helps OEMs design better features and predictive maintenance

# 2. How Do You Work
## Development Process
* Agile, iterative sprints: prototype → OTA orchestration → testing in simulator.
* Focus on Driver Approval, Dependency Check, Vehicle State Condition, and Update Tracker integration.
  
## Planning & Tracking
- Used GitHub Projects + Issues for task tracking.

## Quality Assurance
- Unit testing for update orchestration logic.
- Code reviews of all PRs
- Automated unit and integration tests in simulated vehicles.

## Communication
- Slack + GitHub for async communication.

## Decision Making
- Collaborative → quick discussions in team calls.
- Final technical decisions made by consensus, prioritizing hackathon deadlines.
