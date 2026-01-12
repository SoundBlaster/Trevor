# Tech Spec — Filter Core (Deterministic)

## Objective
Provide a deterministic, low-latency filter for pointer stabilization.

## Base Algorithm
- One Euro Filter (adaptive low-pass)
- Optional median pre-filter for spike suppression

## Parameters
| Name | Description |
|---|---|
| min_cutoff | Base cutoff frequency |
| beta | Speed sensitivity |
| d_cutoff | Cutoff for derivative |

## Preset Mapping
| Preset | min_cutoff | beta |
|---|---:|---:|
| Light | 2.0 | 0.1 |
| Balanced | 1.2 | 0.3 |
| Strong | 0.7 | 0.6 |

## Slider Mapping
- Slider range: `0.0 – 1.0`
- Interpolate between Light (0.0) and Strong (1.0)

## Invariants
- No NaN/Inf output
- Bounded output per frame
- Stable for variable dt
