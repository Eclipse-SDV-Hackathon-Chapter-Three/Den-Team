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
Our Solution – Green OTA with User Choice
We extend OTA with a Green Mode, giving drivers/fleet operators multiple eco-friendly update options, orchestrated by Eclipse Symphony + Ankaios + uProtocol/Zenoh.
1. Two OTA Modes
* Normal OTA → Immediate update, default option.
* Green OTA → User chooses eco-friendly update strategy.
2. Green OTA Options
Update While Charging :zap:
* Updates are scheduled only when EV is charging → zero range loss, often on cleaner grid energy.
* P2P Update with Zenoh/uProtocol :link:
* Vehicle downloads update from nearest charging station or another vehicle → reduces cloud load and cost.
* Wired Workshop Update :hammer_and_wrench:
* Car detects nearest workshop or service depot → update via local wired link → faster + bandwidth-efficient.
* (Extensible) Other options like “Update during low-CO₂ grid hours” or “Update when parked at depot.”
* Delta update → reduce data to be transferred 
3. Gamified Experience :video_game:
* Each green update gives driver points, badges, and eco-feedback:
  - Eco-Champion → Updates done while charging.
  - Carbon Saver → Updates done during low-carbon hours.
  - fleet Hero → Updates received via P2P sharing.
* Dashboard/App shows CO₂ saved, energy conserved, and achievements unlocked.

  
Impact
* Flexibility: Drivers/fleets choose update method → less disruption.
* Sustainability: Cloud offloaded via P2P/workshop updates; charging-time updates cut emissions.
* Engagement: Gamified feedback makes users care about eco-friendly updates.
* Openness: Built on Eclipse stack (Symphony, Ankaios, Zenoh, uProtocol) → vendor-neutral, scalable.

<img width="1972" height="1554" alt="Brainstorming et idéation" src="https://github.com/user-attachments/assets/c2462cf4-6699-44fa-9a9b-698f77489490" />


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
