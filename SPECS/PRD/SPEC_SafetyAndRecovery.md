# Spec — Safety & Recovery

## Objective
Ensure the user can always recover pointer control.

## Panic Disable
- Trigger if app crashes ≥3 times within 60 seconds.
- Next launch starts with stabilization OFF.

## Bypass
- Global shortcut always available.
- Must bypass within one event frame.

## Recovery UX
- Inform user stabilization was disabled.
- Provide button to re-enable.

## Logging
- Local-only crash marker.
- No automatic upload.
