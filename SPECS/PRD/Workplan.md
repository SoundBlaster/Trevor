# Combined Workplan — Mouse Tremor Filter (Web + macOS)

**Purpose:** Unified execution plan integrating web-based demo/feedback tools with macOS application development, enabling parallel work streams and early market validation.

**Scope:** MVP → v1.0, covering both web tools (W0) and macOS implementation (P0-P6).

---

## Phase Overview

| Phase | Track | Name | Goal | Parallelizable |
|---|---|---|---|---|
| W0 | Web | Web Tools | Demo, feedback, dataset seeding | ✓ Fully parallel to P0-P6 |
| P0 | macOS | Foundation | Lock scope, specs, repo structure | — |
| P1 | macOS | FilterCore | Deterministic filtering engine | Partial (after P0.2) |
| P2 | macOS | Event Pipeline | Capture → filter → emit | Partial (after P1.2) |
| P3 | macOS | Application UI | User-facing app & UX | ✓ Parallel to P2-P5 |
| P4 | macOS | Safety & Reliability | Bypass, panic, recovery | Parallel to P3 (after P2.4) |
| P5 | macOS | Trace Export | Dataset-ready local export | ✓ Parallel to P3-P4 |
| P6 | macOS | QA & Release | Verification and packaging | Final phase |

---

## Critical Path Map

```
MACOS PATH (Sequential blocking chain):
P0 → P1 → P2 → P3 → P4 → P6

WEB PATH (Parallel to macOS):
W0 (all subtasks can run in parallel to P0+)
 ├─ W0.1 Landing Page
 ├─ W0.2 Playground (depends on FilterCore logic ported to TS)
 ├─ W0.3 Test Suite (depends on W0.2)
 ├─ W0.4 Feedback Intake
 └─ W0.5 Trace Tuner (internal)

PARALLELIZABLE TRACKS (after dependencies unlock):
P3 can parallelize with P2 (after P2.4)
P4 can parallelize with P3 (after P2.4)
P5 can parallelize with P3/P4
P6 is final integration
```

---

## W0 — Web Tools (Parallel, Non‑blocking)

### W0.1 Landing Page
**Goal:** Explain value + collect interest
**Priority:** High
**Depends On:** —
**Parallelizable:** ✓ (Full parallel to all P phases)
**Output:** `landing/` static page

**Tasks:**
- Write landing page copy
- Create demo GIF (from playground when ready)
- Design "Who this helps" messaging
- Implement email waitlist (optional)
- Add privacy-first statement
- Deploy static site

---

### W0.2 Pointer Stabilization Playground
**Goal:** Instant visual + tactile demo
**Priority:** High
**Depends On:** FilterCore logic ported to TypeScript
**Parallelizable:** ✓ (Parallel after P1.2 complete)
**Output:** Interactive web playground

**Tasks:**
- Port FilterCore algorithm to TypeScript
- Build HTML5 canvas visualization
- Implement raw vs. filtered path rendering
- Add preset selector UI
- Add stability slider
- Implement precision hold (space key)
- Add performance metrics display
- Test cross-browser compatibility

**Entry Criteria:** P1.2 (FilterCore implementation complete)

---

### W0.3 Guided Test Suite
**Goal:** Structured feedback + trace collection
**Priority:** Medium
**Depends On:** W0.2
**Parallelizable:** ✓ (Parallel after W0.2)
**Output:** Guided test interface + local trace export

**Tasks:**
- Design test scenarios (hold steady, slow tracking, fast jumps)
- Build scenario UI with timer
- Implement trace recording (browser-side)
- Create trace ZIP export (local-first, no upload required)
- Add scenario scoring/feedback
- Build results summary view

---

### W0.4 Feedback Intake
**Goal:** Structured qualitative feedback
**Priority:** Medium
**Depends On:** —
**Parallelizable:** ✓ (Full parallel)
**Output:** Feedback collection form + storage

**Tasks:**
- Design feedback schema (OS, device, pain points, helpfulness, etc.)
- Build feedback form UI
- Implement local storage/export (no backend required)
- Add optional trace attachment capability
- Create privacy notice for data handling

---

### W0.5 Trace Replay & Preset Tuner (Internal)
**Goal:** Faster filter iteration and preset refinement
**Priority:** Low
**Depends On:** W0.2
**Parallelizable:** ✓ (Parallel after W0.2)
**Output:** Internal tuning tool

**Tasks:**
- Build trace upload/replay interface
- Implement preset comparison view (side-by-side)
- Add preset parameter editor
- Export tuned preset to JSON
- Add A/B testing view
- Build preset export functionality

---

## P0 — Foundation (Blocking)

| ID | Task | Priority | Depends On | Output |
|---|---|---|---|---|
| P0.1 | Freeze MVP scope | High | — | `SCOPE.md` | [x] **COMPLETED** |
| P0.2 | Finalize specs set | High | P0.1 | Specs bundle approved | [x] **COMPLETED** |
| P0.3 | Repo structure setup | High | P0.1 | Repo skeleton + CI stub | [x] **COMPLETED** |
| P0.4 | CI pipeline (build + test) | Medium | P0.3 | Automated CI |

**Exit Criteria:**
- Scope document reviewed and locked
- Specs approved by stakeholders
- Repository structure ready for all phases
- CI pipeline functional (Swift build, tests passing)

---

## P1 — FilterCore (Critical Path)

| ID | Task | Priority | Depends On | Parallelizable | Output |
|---|---|---|---|---|---|
| P1.1 | Define FilterCore API | High | P0.2 | — | Interface specification |
| P1.2 | Implement One Euro filter | High | P1.1 | — | Filter implementation (Swift) |
| P1.3 | Implement preset mapping | High | P1.2 | — | Preset configuration table |
| P1.4 | Slider → params mapping | High | P1.3 | — | UI mapping function |
| P1.5 | dt normalization & clamping | High | P1.2 | — | Stable delta-time logic |
| P1.6 | Filter invariants tests | High | P1.2 | — | Comprehensive unit tests |
| P1.7 | Performance micro-benchmark | Medium | P1.2 | — | Benchmark report |

**Parallel Opportunities (P1.1 onwards):**
- P1.3 can parallelize with P1.2 (spec-driven)
- P1.5, P1.6 can parallelize with P1.2

**Exit Criteria:**
- No NaN/Inf output under any input
- Stable filtering under variable delta-time
- Presets feel perceptually distinct
- Performance acceptable for 60Hz+ input

**Shared Output for W0.2:** TypeScript port of P1.2 algorithm

---

## P2 — Event Pipeline (Critical Path)

| ID | Task | Priority | Depends On | Parallelizable | Output |
|---|---|---|---|---|---|
| P2.1 | Select event capture mechanism | High | P0.2 | — | Decision doc (EventTap vs. IOKit) |
| P2.2 | Implement event tap capture | High | P2.1 | — | Raw input stream (CGEvent-based) |
| P2.3 | Suppress original events | High | P2.2 | — | Clean pipeline, no duplicates |
| P2.4 | Inject synthetic events | High | P2.3, P1.2 | — | Stabilized pointer output |
| P2.5 | Permission detection logic | High | P2.2 | ✓ | Permission state querying |
| P2.6 | Event rate measurement | Medium | P2.2 | ✓ | Hz diagnostics/monitoring |
| P2.7 | Secure-context fallback | Medium | P2.2 | ✓ | Graceful degradation |

**Parallel Opportunities:**
- P2.5, P2.6, P2.7 can parallelize after P2.2 complete

**Exit Criteria:**
- Pointer moves only via filtered events when enabled
- No pointer freeze possible without bypass hotkey
- Permission handling correct (Accessibility + Recording)
- Event rate stable at target Hz

---

## P3 — Application UI & UX

| ID | Task | Priority | Depends On | Parallelizable | Output |
|---|---|---|---|---|---|
| P3.1 | Settings schema impl | High | P0.2 | — | Versioned config file |
| P3.2 | Menubar controller | High | P2.4 | ✓ | Status UI + menu |
| P3.3 | On/Off + Bypass UI | High | P2.4 | ✓ | Core toggle controls |
| P3.4 | Preset selector UI | High | P1.3 | ✓ | Preset dropdown/picker |
| P3.5 | Stability slider UI | High | P1.4 | ✓ | Interactive slider |
| P3.6 | Precision Hold binding | Medium | P1.4 | ✓ | Hotkey handler (space) |
| P3.7 | Test canvas view | High | P1.2 | ✓ | Visual testing canvas |
| P3.8 | Onboarding wizard | High | P3.1, P2.5 | — | Setup flow + permissions |

**Parallel Opportunities (after P2.4):**
- P3.2, P3.3, P3.4, P3.5, P3.6, P3.7 can parallelize

**Exit Criteria:**
- User can enable/disable safely
- No setting change requires restart
- All UI controls functional and responsive
- Onboarding guides user through permissions

---

## P4 — Safety & Reliability (Blocking before release)

| ID | Task | Priority | Depends On | Output |
|---|---|---|---|---|
| P4.1 | Global bypass hotkey | High | P2.4 | Immediate disable (Cmd+Ctrl+/) |
| P4.2 | Panic crash detection | High | P3.1 | Crash counter + watchdog |
| P4.3 | Safe-start logic | High | P4.2 | Disabled-on-start after crashes |
| P4.4 | Recovery UX | Medium | P4.3 | User prompt + recovery option |
| P4.5 | Local logging policy | Medium | P4.1 | Logs specification |

**Exit Criteria:**
- User always regains control via bypass hotkey
- App recovers automatically from crash loops
- No telemetry or external logging (privacy-first)
- All edge cases tested

---

## P5 — Trace Export (Optional, Parallel)

| ID | Task | Priority | Depends On | Parallelizable | Output |
|---|---|---|---|---|---|
| P5.1 | Recording state machine | Medium | P2.2 | — | Recorder implementation |
| P5.2 | Guided exercise UI | Medium | P5.1 | — | Timed task interface |
| P5.3 | Data schema enforcement | Medium | P0.2 | ✓ | JSON schema files |
| P5.4 | Quality validation | Medium | P5.1 | ✓ | Trace validator |
| P5.5 | ZIP exporter | Medium | P5.4 | ✓ | File export logic |
| P5.6 | Privacy disclosure UI | Medium | P5.5 | ✓ | Consent screen + docs |

**Parallel Opportunities:**
- P5.3, P5.4, P5.5, P5.6 can parallelize after dependencies met

**Exit Criteria:**
- Exported ZIP validates against schema
- No PII leakage possible
- User consent required before export
- Schema compatible with W0.3 format

---

## P6 — QA, Hardening & Release

| ID | Task | Priority | Depends On | Output |
|---|---|---|---|---|
| P6.1 | Golden manual test pass | High | P3.8, P4.* | Test report + sign-off |
| P6.2 | Regression trace replay | Medium | P5.5 | Replay logs + analysis |
| P6.3 | Performance profiling | Medium | P1.7 | Perf report + optimization |
| P6.4 | Signing & notarization | High | P6.1 | Signed, notarized app |
| P6.5 | Release notes + docs | Medium | P6.4 | v1.0 documentation |
| P6.6 | Beta feedback loop setup | Medium | P6.5 | Issue templates + process |

**Exit Criteria (v1.0):**
- All High-priority tasks completed
- Golden test scenarios pass
- Bypass and panic recovery verified manually
- No background data collection
- App usable by non-technical users
- Code signed and notarized for distribution

---

## Integration Points: W0 ↔ P0-P6

### FilterCore Sharing
- **P1.2 output** → ported to TypeScript for **W0.2 Playground**
- Same algorithm, different language implementation
- Keep in sync via shared specification

### Trace Format Compatibility
- **P5.x output** (ZIP schema) ← used by **W0.3 + W0.5**
- Web tools export traces in same format as macOS app
- Enables preset tuning across platforms

### Feedback Loop
- **W0.4 Feedback Intake** → informs P3/P4 iteration
- **W0.5 Trace Tuner** → discovers preset improvements
- Feed findings back into P1.3 preset table

### Marketing & Distribution
- **W0.1 Landing Page** → early awareness + waitlist
- **W0.2 Playground** → demo without requiring macOS
- **P6.5 Release Notes** → unified messaging across platforms

---

## Execution Strategy

### W0 Track (Independent)
- **Start immediately** (no blocking dependencies except P1.2 for W0.2)
- **Team:** Frontend + FilterCore developer
- **Validation:** User feedback collection starting Week 1

### P0 Track (Blocking)
- **Start immediately** (critical path blocker)
- **Duration:** 1-2 weeks
- **Gate:** All downstream work blocked until P0.2 approved

### P1 Track (Critical Path)
- **Start after P0.2** (spec dependency)
- **Parallel:** P1.3, P1.5, P1.6 after P1.2 begins
- **Output to W0:** TS port of algorithm for W0.2

### P2 Track (Critical Path)
- **Start after P0.2** (spec dependency)
- **Parallel:** P2.5, P2.6, P2.7 after P2.2 begins
- **Gate for P3/P4:** P2.4 completion

### P3, P4, P5 (Parallel after unlock)
- **P3** starts after P2.4 + P1.3/P1.4
- **P4** starts after P2.4 (can parallelize with P3)
- **P5** starts after P2.2 (can parallelize with P3/P4)

### P6 (Final Integration)
- **Start after P4 completion**
- **Requires:** P3.8, P4.*, P5.5 (for trace replay)
- **Final gate:** v1.0 quality criteria

---

## Definition of Done (v1.0)

**All tracks complete when:**

### macOS App
- [ ] All High-priority P0-P4 tasks completed
- [ ] Golden test scenarios pass (P6.1)
- [ ] Bypass hotkey functional (P4.1)
- [ ] Panic recovery verified manually (P4.2-P4.3)
- [ ] No background data collection
- [ ] App signed + notarized (P6.4)
- [ ] Usable by non-technical users

### Web Tools
- [ ] W0.1-W0.4 complete (minimum)
- [ ] W0.2 Playground functional with latest FilterCore
- [ ] Feedback collection working
- [ ] Traces exportable in standard format

### Integration
- [ ] FilterCore TS port matches Swift implementation (±0.1px)
- [ ] Trace format compatible across platforms
- [ ] Marketing site live with demo
- [ ] User feedback loop established

---

**End of Combined Workplan**
