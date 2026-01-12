# MVP Scope — Trevor Mouse Tremor Filter

## Introduction
The Trevor Mouse Tremor Filter is designed to stabilize mouse pointer movement for individuals with hand tremors, enabling more accurate and comfortable computer use. This document defines the Minimum Viable Product (MVP) scope for the initial release.

## Included Features

### Core Functionality
- **FilterCore Algorithm**: Implementation of the One Euro filter algorithm for stabilizing mouse pointer movement.
- **Event Pipeline**: Capture raw mouse events, apply filtering, and inject stabilized events.
- **Basic UI Controls**: Enable/disable filtering, preset selection, and stability slider.

### Safety Features
- **Bypass Hotkey**: Immediate disable of filtering via keyboard shortcut (Cmd+Ctrl+/).
- **Panic Recovery**: Automatic detection and recovery from crashes.

### Web Tools
- **Landing Page**: Informational page explaining the project and collecting interest.
- **Pointer Stabilization Playground**: Interactive demo of the filtering algorithm.

## Excluded Features

### Advanced Features
- **Advanced Preset Customization**: Custom preset creation and fine-tuning.
- **Multi-Device Support**: Support for devices other than standard mice.
- **Cloud Sync**: Synchronization of settings across devices.

### Additional Tools
- **Trace Export**: Exporting trace data for analysis.
- **Feedback Intake**: Structured feedback collection system.

## Assumptions
- The MVP will be developed for macOS initially.
- The core filtering algorithm will be implemented in Swift.
- Web tools will be developed using TypeScript and React.

## Constraints
- Development timeline is limited to the initial MVP phase.
- Resources are constrained to the core development team.
- The MVP must be stable and reliable for end-users.

## Approval
- **Stakeholder 1**: [Signature] [Date]
- **Stakeholder 2**: [Signature] [Date]
- **Stakeholder 3**: [Signature] [Date]
```

Now I will update the `next.md` file to reflect the completion of the task and proceed to the ARCHIVE step.