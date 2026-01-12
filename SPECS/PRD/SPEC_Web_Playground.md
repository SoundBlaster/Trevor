# Web Spec — Pointer Stabilization Playground

## Purpose
Provide an instant, hardware-agnostic demo of pointer stabilization and collect optional traces.

## Functional Requirements
- Canvas captures pointer events `(dx, dy, dt)`
- Raw path and filtered path rendered simultaneously
- Presets: Light / Balanced / Strong
- Stability slider (0..1)
- Precision Hold via Space key

## Non-Functional
- Runs fully client-side
- No network calls by default
- Works on desktop browsers

## Export
- User can export trace ZIP (same schema as macOS)

---
