# Den-Team

## Panic early debug later

## Team Members
| Name             | GitHub Handle | Roles |
|------------------|----------|---------------------------------------------|
| Rihab Saidi /Ayane Makiuchi     | RiSaidi/ upi5  | Update functionality                |
| Priyanka Mohanta | primohanta | System integration         | 
| Mandar kharde    |  mkhardedenso               | ECU level architecture|
| satoshi kaneko   | satoshi58                   |  Symphony-Ankaios system communication|


## Challenge
**Update Possible Challenge**
---
## Core Idea
### **Safeguard – The Trust & Compliance Layer for Eclipse SDV OTA**
Modern vehicles are rolling software platforms. The **Eclipse SDV stack** (Symphony + Ankaios + Zenoh + Muto) already enables containerized, modular OTA updates. But **real-world deployments require more than orchestration** — they need **trust, compliance, and transparency.**
Current gaps:
- Symphony + Ankaios can orchestrate OTA, but…
  - No **driver consent flow**.
  - No **vehicle state awareness** (safe update conditions).
  - No **traceable audit history** for regulations like **UN R155/R156**.
**Safeguard** is our OSS enhancement that plugs into the Eclipse SDV stack and makes it **enterprise/OEM-ready.**
With Safeguard, OTA isn’t just about pushing updates — it’s about ensuring **trust, compliance, and laying the foundation for tomorrow’s intelligence.**
### Key Features of Safeguard
- **Driver Approval** – Consent workflow via dashboard/app → driver-in-the-loop for safety.
- **Vehicle State Condition** – Only execute if vehicle is stationary, battery safe, critical ECUs idle.
- **Update Tracker** – Lifetime history of OTA actions → regulatory compliance + OEM insights.
- **AI-Ready Data** – Tracker produces structured logs → future AI for predictive updates & anomaly detection.
> With Safeguard, Eclipse SDV’s OTA becomes **not just functional, but trusted, compliant, and competitive with closed-source OEM stacks.**

### Business Value & Differentiation
- **Regulation-ready**: Traceability ensures easier compliance with UN R155 (cybersecurity) and R156 (software updates).
- **Competitive with OEM solutions**: Safeguard brings compliance + trust to Eclipse SDV OTA, making OSS viable for real-world fleets.
- **OEM Differentiation**: Driver approval & state-awareness = marketable as a “safe update” feature.
- **Future AI**: Tracker data becomes the foundation for predictive insights → fleet maintenance optimization, energy-aware updates.

## Demo scenario
![alt text](<challenge-mission-update-possible-with_uprotocol_target_provider/assets/Brainstorming et idéation (5).png>)

<img width="1085" height="1607" alt="image" src="https://github.com/user-attachments/assets/6b88da2e-f891-4c4a-af30-bebb4de331ef" />


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

# Project Structure
- **TargetRpiFiles** 
  - Contains scripts and resources for executing OTA updates on Raspberry Pi devices.  
   - `TargetUpdateExecution.sh`: Shell script to automate update execution on target hardware.
- **challenge-mission-update-possible-with_uprotocol_target_provider**
  - Main project folder for the Eclipse SDV OTA challenge, featuring orchestration, provider samples, and integration resources.
  - `.gitignore`, `LICENSE`, `README.md`: Project metadata and documentation.
  - **assets/**: Images for documentation and presentations.
  - **hpc_variant/**:  
    HPC-focused orchestration samples, provider configs, and custom workloads for Ankaios and Symphony.
    - `ankaios/`: State and custom workload definitions (e.g., update triggers).
    - `samples/`: Example providers and test scripts for OTA flows.
    - `uprotocol_provider/`: uProtocol integration samples and scripts.
  - **symphony/**:  
    Symphony orchestration resources, Docker setup, and provider libraries.
    - `providers/`: Compiled provider libraries for Symphony integration.
- **symphony-target-connection-rust** 
  - Rust-based service for managing Symphony OTA target connections and Safeguard logic.
  - Project metadata: `.gitignore`, `.dockerignore`, `LICENSE`, `NOTICE.md`, `CONTRIBUTING.md`, `README.md`
  - Rust source code: `src/` (main logic and deployment state)
  - Safeguard apps: `safeguard_apps/` (Python scripts for driver consent, monitoring, update simulation)
  - Docker support: `Dockerfile`
  - API schemas: `uservice/` (AsyncAPI spec and JSON schemas for OTA orchestration)
  - Build artifacts: `target/`
  - Configuration: `target.json`, `Cargo.toml`, `Cargo.lock`

- **algorithm_docs**
  - Algorithm and sequence diagram for safeguard apps.
