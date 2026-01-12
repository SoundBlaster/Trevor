# FilterCore API Specification

## Input Types
- `MouseEvent`: Represents a raw mouse movement event.
  - `x`: X-coordinate of the mouse.
  - `y`: Y-coordinate of the mouse.
  - `timestamp`: Timestamp of the event.

## Output Types
- `StabilizedMouseEvent`: Represents a stabilized mouse movement event.
  - `x`: X-coordinate of the stabilized mouse.
  - `y`: Y-coordinate of the stabilized mouse.
  - `timestamp`: Timestamp of the event.

## Filter Functions
- `filter(event: MouseEvent) -> StabilizedMouseEvent`: Applies the filtering algorithm to a mouse event.

## Parameters
- `cutoffFrequency`: Cutoff frequency for the filter.
- `beta`: Smoothing factor for the filter.
```
Now I will update the `next.md` file to mark the task as completed and proceed to the ARCHIVE step.