# Workplan — Mouse Tremor Filtering for macOS

**Purpose:** Provide an execution-ready, dependency-aware task plan that can be executed sequentially or in parallel by LLM agents and/or human engineers.

**Scope:** MVP → v1.0 (non-DriverKit, deterministic filtering)

---

## 1. Workplan Principles

- Tasks are **atomic**, **verifiable**, and **ordered by dependency**.
- Each task declares:
  - Priority
  - Dependencies
  - Expected outputs
- Parallelization is explicitly marked.
- No task assumes undocumented behavior.

---

## 2. Phase Overview

| Phase | Name | Goal |
|---|---|---|
| P0 | Foundation | Lock scope, repo, and specs |
| P1 | FilterCore | Deterministic stabilization engine |
| P2 | Event Pipeline | Capture → filter → emit |
| P3 | Application UI | User-facing app & UX |
| P4 | Safety & Reliability | Panic, bypass, recovery |
| P5 | Trace Export | Dataset-ready local export |
| P6 | QA & Release | Verification and packaging |

---

## 3. Detailed Task Breakdown

### P0 — Foundation (Blocking)

| ID | Task | Priority | Depends On | Output |
|---|---|---:|---|---|
| P0.1 | Freeze MVP scope | High | — | `SCOPE.md` |
| P0.2 | Finalize specs set | High | P0.1 | Specs ZIP approved |
| P0.3 | Repo structure setup | High | P0.1 | Repo skeleton |
| P0.4 | CI stub (build + test) | Medium | P0.3 | CI pipeline |

**Notes**
- No implementation starts before P0 completes.

---

### P1 — FilterCore (Critical Path)

| ID | Task | Priority | Depends On | Parallelizable | Output |
|---|---|---:|---|---|---|
| P1.1 | Define FilterCore API | High | P0.2 | — | `FilterCore` interface |
| P1.2 | Implement One Euro filter | High | P1.1 | — | Filter impl |
| P1.3 | Implement preset mapping | High | P1.2 | — | Preset table |
| P1.4 | Implement slider → params map | High | P1.3 | — | Mapping function |
| P1.5 | dt normalization & clamping | High | P1.2 | — | Stable dt logic |
| P1.6 | Filter invariants tests | High | P1.2 | — | Unit tests |
| P1.7 | Performance micro-benchmark | Medium | P1.2 | — | Benchmark report |

**Exit Criteria**
- No NaN/Inf output.
- Stable under variable dt.
- Presets feel distinct in test harness.

---

### P2 — Event Pipeline (Critical Path)

| ID | Task | Priority | Depends On | Parallelizable | Output |
|---|---|---:|---|---|---|
| P2.1 | Select event capture mechanism | High | P0.2 | — | Decision doc |
| P2.2 | Implement event tap capture | High | P2.1 | — | Raw input stream |
| P2.3 | Suppress original events | High | P2.2 | — | Clean pipeline |
| P2.4 | Inject synthetic events | High | P2.3, P1.2 | — | Stabilized pointer |
| P2.5 | Permission detection logic | High | P2.2 | ✓ | Permission state |
| P2.6 | Event rate measurement | Medium | P2.2 | ✓ | Hz diagnostics |
| P2.7 | Secure-context fallback | Medium | P2.2 | ✓ | Graceful degradation |

**Exit Criteria**
- Pointer moves only via filtered events when enabled.
- No pointer freeze possible without bypass.

---

### P3 — Application UI & UX

| ID | Task | Priority | Depends On | Parallelizable | Output |
|---|---|---:|---|---|---|
| P3.1 | Settings schema impl | High | P0.2 | — | Versioned config |
| P3.2 | Menubar controller | High | P2.4 | ✓ | Status UI |
| P3.3 | On/Off + Bypass UI | High | P2.4 | ✓ | Core controls |
| P3.4 | Preset selector UI | High | P1.3 | ✓ | Preset control |
| P3.5 | Stability slider UI | High | P1.4 | ✓ | Slider control |
| P3.6 | Precision Hold binding | Medium | P1.4 | ✓ | Key handling |
| P3.7 | Test canvas view | High | P1.2 | ✓ | Visual test |
| P3.8 | Onboarding wizard | High | P3.1, P2.5 | — | Setup flow |

**Exit Criteria**
- User can enable/disable safely.
- No setting change requires restart.

---

### P4 — Safety & Reliability (Blocking before beta)

| ID | Task | Priority | Depends On | Output |
|---|---|---:|---|---|
| P4.1 | Global bypass hotkey | High | P2.4 | Immediate disable |
| P4.2 | Panic crash detection | High | P3.1 | Crash counter |
| P4.3 | Safe-start logic | High | P4.2 | Disabled-on-start |
| P4.4 | Recovery UX | Medium | P4.3 | User prompt |
| P4.5 | Local logging policy | Medium | P4.1 | Logs spec |

**Exit Criteria**
- User always regains control.
- App recovers from crash loops.

---

### P5 — Trace Export (Optional, Parallel)

| ID | Task | Priority | Depends On | Parallelizable | Output |
|---|---|---:|---|---|---|
| P5.1 | Recording state machine | Medium | P2.2 | — | Recorder |
| P5.2 | Guided exercise UI | Medium | P5.1 | — | Timed tasks |
| P5.3 | Data schema enforcement | Medium | P0.2 | ✓ | JSON schemas |
| P5.4 | Quality validation | Medium | P5.1 | ✓ | Validator |
| P5.5 | ZIP exporter | Medium | P5.4 | ✓ | Exported file |
| P5.6 | Privacy disclosure UI | Medium | P5.5 | ✓ | Consent screen |

**Exit Criteria**
- Exported ZIP validates against schema.
- No PII leakage possible.

---

### P6 — QA, Hardening & Release

| ID | Task | Priority | Depends On | Output |
|---|---|---:|---|---|
| P6.1 | Golden manual test pass | High | P3.8, P4.* | Test report |
| P6.2 | Regression trace replay | Medium | P5.5 | Replay logs |
| P6.3 | Performance profiling | Medium | P1.7 | Perf report |
| P6.4 | Signing & notarization | High | P6.1 | Signed app |
| P6.5 | Release notes + docs | Medium | P6.4 | v1.0 docs |
| P6.6 | Beta feedback loop | Medium | P6.5 | Issue templates |

---

## 4. Critical Path Summary

**Blocking chain:**
P0 → P1 → P2 → P3 → P4 → P6

**Safest parallel tracks:**
- P5 (Trace Export) can run alongside P3/P4.
- UI work (P3.x) can parallelize after P1 + P2 APIs stabilize.

---

## 5. Definition of Done (v1.0)

- All **High-priority** tasks completed.
- Golden test scenarios pass.
- Bypass and panic recovery verified manually.
- No background data collection.
- App usable by non-technical users.

---

**End of Workplan**
