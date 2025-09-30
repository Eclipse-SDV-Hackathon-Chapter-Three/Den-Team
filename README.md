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
What is your rough solution idea?
Green Update Challenge

**Problem:**
 OTA updates today are wasteful (full firmware flashes, heavy downloads), fragmented (HPC vs ECU mismatch), and invisible to the end-user. Drivers and fleet operators don’t see the environmental or performance value of updates.

**Solution:**
We designed Gamified Green OTA using Eclipse Symphony + Eclipse Ankaios:
- Symphony builds delta update bundles (HPC container layers + ECU firmware diffs).
- Ankaios orchestrates updates in-vehicle → schedules them during charging/low-carbon energy windows.
- Updates are safer with rollback (via Muto) and more efficient with peer-to-peer sharing (Zenoh).
- End-users (drivers/fleet operators) see gamified green feedback: CO₂ saved, badges, and achievements (e.g., Eco-Champion, Carbon Saver).


# 2. How Do You Work
## Development Process
Iterative development with short sprints.
Focused first on getting Symphony :left_right_arrow: Ankaios pipeline working.
Added gamification UI later for end-user value.
  
## Planning & Tracking
- Used GitHub Projects + Issues for task tracking.

## Quality Assurance
How do you ensure quality (e.g., testing, documentation, code reviews)?
Unit testing for update orchestration logic.

## Communication
Slack + GitHub for async communication.

## Decision Making
Collaborative → quick discussions in team calls.
Final technical decisions made by consensus, prioritizing hackathon deadlines.
