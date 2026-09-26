# EHMTA

Ephemeral Host Management & Telemetry Agent.

Windows endpoint inventory, diagnostics, telemetry, management, artifact transfer,
and controlled update infrastructure.

## Architecture

Agent
├── Core
├── Inventory
├── Diagnostics
├── Telemetry
├── Management
├── Artifacts
├── Transport
├── Policy
└── UI

Builder
└── EHMTA-BUILDER.ps1

Dashboard
└── Multi-device management interface

## Installation

irm https://raw.githubusercontent.com/vxssroott/EHMTA/main/install-EHMTA.ps1 | iex

