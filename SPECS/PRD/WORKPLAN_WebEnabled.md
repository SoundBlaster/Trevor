# Workplan — Mouse Tremor Filtering (with Web Tools Track)

## Purpose
Execution-ready task plan including **Web-based demo & feedback tools** used for:
- early validation
- dataset collection (local-first)
- marketing / demo without Apple hardware

---

## Phase Map

| Phase | Name | Goal |
|---|---|---|
| W0 | Web Tools | Demo, feedback, dataset seeding |
| P0 | Foundation | Scope & specs |
| P1 | FilterCore | Deterministic filtering |
| P2 | Event Pipeline | Capture → filter → emit |
| P3 | App UX | macOS application |
| P4 | Safety | Bypass & recovery |
| P5 | Trace Export | Dataset |
| P6 | QA & Release | v1.0 |

---

## W0 — Web Tools (Parallel, Non‑blocking)

### W0.1 Landing Page
**Goal:** explain value + collect interest

- Demo GIF (from playground)
- “Who this helps” bullets
- Email waitlist (optional)
- Privacy-first statement

**Priority:** High  
**Output:** `landing/` static page

---

### W0.2 Pointer Stabilization Playground
**Goal:** instant visual + tactile demo

- HTML canvas
- Raw vs filtered path
- Presets + stability slider
- Precision hold (space key)

**Priority:** High  
**Depends on:** FilterCore logic (ported to TS)

---

### W0.3 Guided Test Suite
**Goal:** structured feedback + traces

- Hold steady
- Slow tracking
- Fast jumps
- Export trace ZIP (local)

**Priority:** Medium  
**Depends on:** W0.2

---

### W0.4 Feedback Intake
**Goal:** structured qualitative feedback

- OS / device (optional)
- Pain points
- Helpfulness score
- Upload trace (opt-in)

**Priority:** Medium  

---

### W0.5 Trace Replay & Preset Tuner (Internal)
**Goal:** faster filter iteration

- Upload trace
- Compare presets
- Export preset JSON

**Priority:** Low  

---

## Dependencies Summary

- W0 track is **fully parallel** to macOS work.
- FilterCore math is shared (Swift ↔ TypeScript).
- Web demo is first marketing surface.

---

**End of Workplan**
