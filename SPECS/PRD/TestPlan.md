# QA Test Plan

**Purpose:** Comprehensive testing strategy covering FilterCore algorithm, event pipeline, UI, safety features, and web tools across development phases.

**Scope:** Unit tests → integration tests → golden manual tests → regression suite (aligned with Workplan.md phases P0-P6 and W0).

---

## 1. Test Strategy Overview

| Phase | Test Focus | Owner | Timing |
|---|---|---|---|
| P1 (FilterCore) | Unit + algorithm tests | Dev | During implementation |
| P2 (Event Pipeline) | Integration + event handling | Dev + QA | During implementation |
| P3 (UI) | Functional + UX | QA | During implementation |
| P4 (Safety) | Bypass, panic, recovery | QA | Before beta |
| P5 (Trace Export) | Data integrity + schema | Dev + QA | During implementation |
| W0 (Web Tools) | Playground + feedback flow | Frontend QA | Parallel to macOS |
| P6 (QA & Release) | Golden tests + regression | QA | Before shipping |

---

## 2. Automated Tests (Unit + Integration)

### 2.1 FilterCore Tests (P1.6 deliverable)

**Goal:** Ensure mathematical correctness and numerical stability.

#### Unit Tests
- **No NaN/Inf output**
  - Test with: zero input, large jumps, rapid oscillation, long pauses (variable dt)
  - Verify output is always finite and bounded

- **Filter invariants**
  - Output magnitude ≤ input magnitude
  - Smooth transition (no sudden jumps in output)
  - Monotonic response to step input

- **Preset validation**
  - Each preset produces perceptually distinct smoothing
  - Presets are reproducible across runs
  - Parameter ranges valid (no negative frequencies, etc.)

- **Delta-time (dt) handling (P1.5)**
  - dt=0 doesn't cause division by zero
  - Very large dt (>1s) doesn't destabilize filter
  - Clamped dt range maintains stability
  - Consistent output regardless of frame rate (60Hz vs. 120Hz)

- **Edge cases**
  - First input (initialization)
  - Repeated identical inputs (convergence)
  - Sign changes (tremor in opposite directions)
  - Mixed input rates (variable Hz)

**Test Framework:** XCTest (Swift unit tests)
**Coverage Target:** 100% of FilterCore code paths

---

### 2.2 Event Pipeline Tests (P2.2-P2.4)

**Goal:** Verify capture, filtering, and injection work correctly.

#### Event Capture Tests
- **Raw input stream integrity**
  - All mouse movements captured at expected rate
  - No dropped events
  - Event timestamps monotonically increasing
  - Event order preserved

- **Permission handling (P2.5)**
  - Accessibility permissions requested/denied correctly
  - Recording permissions detected
  - Graceful fallback when permissions missing

#### Event Filtering Tests
- **Filter pipeline correctness**
  - Raw event → filter → synthetic event chain works
  - No event duplication
  - Filtering applies to x, y coordinates independently
  - Filter state persists across events

#### Event Injection Tests
- **Synthetic event emission**
  - Injected events appear as legitimate mouse movement
  - Injection timing correct (≤1ms latency)
  - No event feedback loops
  - Pointer position matches injected coordinates

#### Suppression Tests
- **Original event blocking**
  - Original tremor events suppressed when enabled
  - Suppression stops when filter disabled
  - No pointer "jumping" on enable/disable
  - Suppression granular (only affects movement, not clicks)

**Test Framework:** XCTest with CGEvent injection/monitoring
**Environment:** Automation server (headless testing with simulated input)

---

### 2.3 Settings & Persistence Tests (P3.1)

- **Settings schema validation**
  - Valid settings file loads without error
  - Corrupted settings gracefully fallback to defaults
  - Settings version migration works

- **Preset persistence**
  - Custom presets saved and loaded
  - Slider position persists across restart
  - On/off state remembered

- **State transitions**
  - Enable → disable → enable maintains consistency
  - Changing presets while enabled is safe
  - Changing stability slider is smooth (no jumps)

**Test Framework:** XCTest with temp config files

---

### 2.4 Trace Export Tests (P5)

- **Data schema compliance**
  - Exported ZIP follows JSON schema
  - All required fields present
  - Timestamp format correct
  - Data types match spec

- **Trace integrity**
  - Recorded trace matches actual pointer movements
  - Trace timestamps accurate
  - No data corruption in ZIP archive

- **Quality validation (P5.4)**
  - Invalid traces rejected by validator
  - Valid traces pass all checks
  - Schema version tracked

**Test Framework:** Custom validation tool + schema checker

---

### 2.5 Web Tool Tests (W0)

**Automated testing for:**
- **Playground (W0.2)**
  - Canvas rendering (raw vs. filtered paths)
  - Preset switching updates visualization
  - Slider changes filter responsiveness
  - Space key toggling precision hold
  - Performance: <16ms frame time (60 FPS)

- **Test Suite (W0.3)**
  - Guided test scenarios run without errors
  - Trace recording captures all events
  - ZIP export succeeds
  - Scoring logic correct

- **Feedback Form (W0.4)**
  - Form validation works
  - Data persists locally
  - No network requests (privacy-first)

**Test Framework:** Jest + React Testing Library (browser tests)
**Environment:** Chromium/Firefox/Safari (automated)

---

## 3. Integration Tests

### 3.1 End-to-End Filter Pipeline
**Scenario:** Raw input → FilterCore → synthetic event → visible pointer movement

- Inject raw tremor pattern
- Verify stabilization visible on screen
- Confirm original events suppressed
- Measure latency E2E

**Tool:** Custom input injector + screen capture
**Pass Criteria:** <2ms latency, tremor reduction ≥70%

---

### 3.2 Settings → Behavior Pipeline
**Scenario:** Change preset/slider → filter output updates

- Enable with Preset A
- Switch to Preset B
- Verify visual difference in pointer
- Switch back to A
- Confirm same behavior as first enable

**Pass Criteria:** No state corruption, smooth transitions

---

### 3.3 Permission Flow
**Scenario:** First run → permission prompt → filtering enabled

- Clean app state
- Trigger first-run onboarding (P3.8)
- Grant Accessibility permission
- Enable filtering
- Verify input captured

**Pass Criteria:** Permission flow completes, no crashes

---

## 4. Manual Golden Tests (P6.1)

### 4.1 Core Functionality

**Test: Small Target Clicking**
- Scenario: Click small UI elements with hand tremor active
- Setup: Enable filter, choose "Fine Control" preset
- Expected: Accurate clicks without slip
- Acceptance: 20/20 successful clicks on 8×8px targets
- Test Duration: 2 min

**Test: Text Selection**
- Scenario: Select text in document with tremor enabled
- Setup: Open text editor, enable filter
- Expected: Smooth selection without stuttering
- Acceptance: Select 5 sentences without errors
- Test Duration: 3 min

**Test: Drag & Drop**
- Scenario: Drag file/window with tremor active
- Setup: Enable filter, drag 5 files between folders
- Expected: Pointer path smooth, drop lands on target
- Acceptance: All 5 drops successful
- Test Duration: 3 min

**Test: Rapid Movement**
- Scenario: Quick gestures (swipes, rapid clicking)
- Setup: Enable filter, perform fast pointer movements
- Expected: Filter doesn't add latency, movements feel natural
- Acceptance: No lag perceptible, max latency <20ms
- Test Duration: 2 min

**Test: Extended Use (30 min)**
- Scenario: Use macOS normally with filter enabled
- Setup: Enable filter, use apps (text editor, browser, finder)
- Expected: No crashes, no freezes, no memory leak
- Acceptance: App stable, memory <100MB
- Test Duration: 30 min

---

### 4.2 Safety & Reliability

**Test: Bypass Hotkey (P4.1)**
- Scenario: Enable filter, press Cmd+Ctrl+/ to disable
- Expected: Pointer immediately unfrozen if tremor caused pause
- Acceptance: Bypass responds within 10ms
- Test Duration: 1 min

**Test: Panic Recovery (P4.2-P4.3)**
- Scenario: Simulate app crash, restart
- Expected: App launches with filter disabled
- Verification: Check crash counter in logs
- Acceptance: Auto-disable on 3 crashes in 10 min
- Test Duration: 5 min

**Test: Permission Loss**
- Scenario: Disable Accessibility permission while filtering
- Expected: App detects loss gracefully, disables filter with warning
- Acceptance: No crash, user notified
- Test Duration: 2 min

---

### 4.3 Settings & Presets

**Test: Preset Switching**
- Scenario: Enable filter, switch between 4 presets
- Expected: Each preset produces distinct feel
- Acceptance: Perceptual difference clear, no state corruption
- Test Duration: 3 min

**Test: Stability Slider**
- Scenario: Drag slider left/right while filtering active
- Expected: Smooth response, no jumps or freezes
- Acceptance: All positions stable, UI responsive
- Test Duration: 2 min

**Test: Settings Persistence**
- Scenario: Set preset, enable, close app, reopen
- Expected: Settings restored
- Acceptance: Preset + on/off state match previous session
- Test Duration: 2 min

---

### 4.4 Web Tool Testing (W0)

**Test: Playground Demo**
- Scenario: Open W0.2 Playground in browser
- Expected: Canvas renders, presets work, slider responsive
- Acceptance: All UI interactive, no JS errors
- Test Duration: 3 min

**Test: Guided Test Suite**
- Scenario: Complete W0.3 test flow (hold, track, jump)
- Expected: Scoring displays, trace exports
- Acceptance: All 3 test types scoreable, ZIP valid
- Test Duration: 5 min

**Test: Feedback Form**
- Scenario: Fill W0.4 feedback form, submit
- Expected: Data persists locally
- Acceptance: No network request, data retrievable
- Test Duration: 2 min

---

## 5. Regression Test Suite

**Goal:** Prevent reintroduction of fixed bugs across releases.

### 5.1 Trace Replay (P6.2)
- Use library of previously recorded problem traces (tremor patterns, edge cases)
- Replay against FilterCore
- Verify output matches baseline (within tolerance)
- Pass Criteria: All traces produce stable, bounded output

**Tool:** Custom replay framework (trace files + expected output)
**Frequency:** Every build

---

### 5.2 Automated Regression (CI)
- Run all unit tests (P1.6)
- Run all integration tests (section 3)
- Trace replay suite
- Performance benchmark (P1.7)

**Pass Criteria:**
- All tests pass
- Performance within 5% of baseline
- No new crashes in logs

**Frequency:** On every commit (CI/CD pipeline)

---

### 5.3 Manual Regression (Pre-release)
- Execute subset of golden tests (4.1 essential scenarios)
- Verify bypass always works (4.2)
- Spot-check 2 presets + slider (4.3)
- Quick web tool smoke test (4.4)

**Time:** ~15 minutes
**Frequency:** Before each release

---

## 6. Performance Testing (P1.7, P6.3)

### Benchmarks
- **FilterCore latency:** <1ms per sample (target: <0.5ms)
- **Event injection latency:** <2ms E2E
- **Memory footprint:** <100MB sustained
- **CPU usage:** <5% background (idle)
- **Frame rate impact:** ≤5% drop from baseline

### Load Testing
- Sustained input at 120Hz (iPad-class input rate)
- 1000 consecutive events without NaN/Inf
- Long run (1 hour) without memory leak

**Tool:** Instruments (Time Profiler, Allocations)
**Gate:** Must meet all benchmarks before release

---

## 7. Test Environment & Tools

| Component | Tool | Notes |
|---|---|---|
| Swift unit tests | XCTest | Integrated into Xcode |
| Event injection | CGEvent API + custom harness | Headless automation |
| Web tests | Jest + React Testing Library | npm test |
| Trace replay | Custom Python/Swift tool | Batch processing |
| Performance | Instruments + custom benchmarks | Manual profiling |
| Manual testing | Tester + macOS device | Real device required |

---

## 8. Test Execution Schedule

| Phase | When | What | Duration |
|---|---|---|---|
| P1 | Daily | Unit tests (FilterCore) | <5 min |
| P2 | Daily | Unit + integration (pipeline) | <10 min |
| P3 | Daily | Functional tests (UI) | <15 min |
| P4 | Before beta | Safety tests (full manual) | 30 min |
| P5 | During impl | Data integrity tests | <10 min |
| P6 | Pre-release | Golden tests + regression | 1-2 hours |
| W0 | Continuous | Web tool tests + manual | <20 min |

---

## 9. Acceptance Criteria (Definition of Done)

**macOS App (P6)**
- ✓ All automated tests pass (100% pass rate)
- ✓ All golden manual tests pass (100% pass rate)
- ✓ Bypass hotkey verified working
- ✓ Panic recovery verified (manual)
- ✓ Performance benchmarks met
- ✓ Trace replay suite clean (no regressions)
- ✓ Zero known crashes in QA session
- ✓ Memory stable (<100MB sustained)

**Web Tools (W0)**
- ✓ Playground renders correctly across browsers
- ✓ Feedback form collects data locally
- ✓ Traces export valid ZIP
- ✓ All manual smoke tests pass

**Release (v1.0)**
- ✓ All above criteria met
- ✓ Code signed and notarized
- ✓ Release notes published
- ✓ Beta feedback issues triaged

---

## 10. Risk Mitigation

| Risk | Mitigation | Owner |
|---|---|---|
| dt instability | P1.5 + thorough dt testing | Dev |
| Event suppression breaking clicks | P2.3 event granularity testing | Dev |
| Bypass failure under load | Load test + manual verification | QA |
| Trace export PII leak | Schema validation + privacy audit | Dev |
| Permission cascade failure | Permission flow integration test | QA |

---

**End of QA Test Plan**
