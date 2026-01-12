# Tech Spec — Event Capture & Output Pipeline

## Objective
Define a deterministic, user-space strategy for capturing mouse input, applying stabilization, and reinjecting events on macOS **without DriverKit**.

## Strategy
- Use a **global event tap** to capture mouse movement events.
- Suppress original movement events.
- Emit synthetic, stabilized movement events.

## Permissions
- Accessibility: required to install event tap and post synthetic events.
- Input Monitoring: required to observe raw mouse deltas (implementation-dependent).

## Fallback Behavior
- If permissions are missing:
  - Stabilization is disabled.
  - App enters “Setup Required” state.
  - Test Canvas remains available.

## Limitations
- Secure input contexts may bypass event taps.
- Some full-screen apps may behave differently.

## Data Flow
1. OS → Event Tap → Raw `(dx, dy, timestamp)`
2. Normalize to `(dx, dy, dt)`
3. Apply FilterCore
4. Emit synthetic event
