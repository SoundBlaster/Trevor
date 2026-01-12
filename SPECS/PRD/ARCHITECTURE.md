# Architecture Overview

## Modules
- App (UI, onboarding)
- EventPipeline
- FilterCore
- TraceExport
- Diagnostics

## Dependency Rules
- FilterCore has no AppKit dependency.
- EventPipeline depends on FilterCore.

## Build
- Single app target (MVP)
- Future DriverKit extension optional.
