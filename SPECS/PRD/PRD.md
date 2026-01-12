# PRD — Mouse Tremor Filtering for macOS (Assistive Pointer Stabilization)

**Document status:** Draft v1.0  
**Audience:** Engineering (LLM agents + humans), Design, QA, Release/Ops  
**Project type:** Non-commercial / assistive tool / privacy-first  
**Primary platform:** macOS (initial), Apple Silicon + Intel (as supported by target macOS versions)

---

## 0. Glossary

| Term | Definition |
|---|---|
| **Pointer Stabilization** | Real-time filtering of raw mouse movement deltas to reduce high-frequency jitter while preserving intentional motion. |
| **Tremor** | Unintentional, high-frequency oscillation in hand movement causing cursor jitter. The app does not diagnose or treat tremor. |
| **Bypass** | Immediate disabling of stabilization to restore unfiltered pointer behavior. |
| **Precision Hold** | A temporary mode (while a key/button is held) that increases stability and/or reduces speed for fine targeting. |
| **Preset** | A named configuration bundle (e.g., Light/Balanced/Strong) mapping to deterministic filter parameters. |
| **Trace Export** | User-initiated local recording of movement deltas for debugging and future research. Never automatic. |
| **MVP** | Minimal feature set needed to validate user value and gather feedback. |
| **DriverKit Virtual HID** | Optional later architecture where a virtual mouse device is created and fed stabilized deltas. Not part of early MVP. |

---

## 1. Objective, Scope, and Intent

### 1.1 Objective (Restated)
Build a macOS application that **reduces pointer jitter** for users affected by tremor by **filtering raw mouse movement deltas** in real time, with **minimal perceived latency** and **predictable behavior**, while offering **simple presets**, **instant bypass**, and **a guided setup**.

### 1.2 In-Scope (v1.0)
- A **non-DriverKit** macOS application that provides pointer stabilization using deterministic filtering.
- Simple UX:
  - On/Off toggle
  - Presets (Light/Balanced/Strong)
  - Precision Hold
  - A single primary tuning slider (“Stability ↔ Responsiveness”) with clear semantics
- A **test canvas** for “feel” and basic sanity checks.
- **Local-first diagnostics** (no background telemetry).
- **Optional trace export** (user-initiated, guided exercises, privacy-preserving).

### 1.3 Out-of-Scope (v1.0)
- ML-based filtering or ML-based personalization (explicitly excluded).
- Medical claims, diagnosis, or condition-specific recommendations.
- Always-on cloud upload, background telemetry, or analytics.
- Per-app profiles (optional post-1.0).
- DriverKit System Extension / Virtual HID (decision gate only; implementation is post-MVP).

### 1.4 Assumptions
- Users can grant required macOS permissions (Accessibility / Input Monitoring as applicable to implementation).
- Deterministic filtering can provide meaningful improvement for a meaningful fraction of users.
- The app can provide value without DriverKit by capturing pointer events and applying stabilization in user space.

### 1.5 External Dependencies
- macOS permission systems (TCC): Accessibility / Input Monitoring (exact set depends on implementation approach).
- Packaging/signing/notarization pipeline for macOS app distribution.
- (Future) DriverKit entitlement approval if the Virtual HID track is pursued.

---

## 2. Primary Deliverables and Success Criteria

### 2.1 Deliverables
1. **macOS App (MVP → v1.0)** with stabilization, presets, bypass, precision hold, test canvas, and setup wizard.
2. **User documentation** (README/Help): installation, permissions, troubleshooting, privacy.
3. **Trace export** module producing a documented ZIP format (optional user contribution).
4. **QA plan** with a “golden manual test checklist” for must-work scenarios.
5. **Release checklist** (signing, notarization, permissions flow).

### 2.2 Success Criteria (Measurable)
- **User value:** ≥ 70% of beta testers (n ≥ 20) report improvement in at least one must-work scenario (precise pointing, text selection, drag & drop).
- **Latency perception:** ≤ 20% of testers describe cursor as “laggy” or “rubber-band” on Balanced preset.
- **Bypass reliability:** Bypass toggling works instantly in ≥ 99% of attempts during QA sessions.
- **Setup success:** ≥ 80% of non-technical testers can complete onboarding without external help (given clear on-screen instructions).
- **Privacy trust:** No background data collection; trace export is opt-in and clearly explained.

---

## 3. Users, Personas, and Use Cases

### 3.1 Personas
- **P1 — Primary User:** Person affected by tremor who struggles with fine cursor control.
- **P2 — Caregiver/Family:** Configures the Mac and wants “simple, safe, reversible” settings.
- **P3 — Helper Professional:** Therapist/rehab specialist evaluating assistive tooling (secondary).

### 3.2 Must-Work Use Cases
1. **Targeting:** Hover and click small UI elements (window controls, icons, checkboxes).
2. **Text selection:** Click-and-drag to highlight text reliably.
3. **Drag & drop:** Move files/icons without jitter-induced drops.
4. **General navigation:** Menus, pointer movement while reading, typical office workflows.

### 3.3 Nice-to-Have Use Cases (Post-1.0)
- Creative apps (drawing/tablet-like precision).
- Optional gaming profile (strict latency constraints).
- Per-app profiles and user profile export/import.

---

## 4. Product Principles and Constraints

### 4.1 Product Principles
1. **Presets-first:** Offer effective defaults before exposing tuning.
2. **Predictable behavior:** Avoid “smart” behavior that surprises users.
3. **Safety:** Always provide instant bypass and a recovery path if the app misbehaves.
4. **Local-first privacy:** No background upload; trace export is explicit and documented.
5. **Accessibility-first UX:** Simple language, big controls, minimal steps.

### 4.2 Constraints
- Must comply with macOS permission prompts and OS security policies.
- Must avoid capturing sensitive data (no keystrokes, no app/window titles, no screen coordinates in exports).
- Must remain responsive under high polling rates (500–1000 Hz typical).

---

## 5. Feature Set (v1.0)

### 5.1 Core Stabilization
**Description:** Apply deterministic filtering to pointer movement deltas to reduce high-frequency jitter.

**Requirements**
- The stabilization pipeline MUST accept inputs as `(dx, dy, dt)` and output stabilized `(dx', dy')` with bounded latency.
- The app MUST support three presets:
  - Light
  - Balanced (default)
  - Strong
- The app MUST provide a global toggle (On/Off).
- The app MUST provide a global **Bypass** shortcut to disable filtering instantly.

**Rationale**
- Different users tolerate different latency vs stability; presets provide fast on-ramp.

### 5.2 Primary Tuning Control (Simple Slider)
**Description:** Provide one “human” control that maps to filter aggressiveness.

**Requirements**
- Expose a single slider labeled **Stability ↔ Responsiveness**.
- Slider MUST map deterministically to filter parameters (document mapping internally).
- Slider MUST have a default midpoint aligned with Balanced preset behavior.
- Slider MUST not expose technical units (Hz, cutoffs) in the main UI.

### 5.3 Precision Hold
**Description:** Temporary mode for fine targeting.

**Requirements**
- User can select a key (or a default key is provided) that activates Precision Hold while pressed.
- Precision Hold MUST either:
  - increase stability (stronger smoothing), OR
  - reduce cursor speed, OR
  - both (implementation-defined), but MUST be consistent and documented.
- The UI MUST show when Precision Hold is active (e.g., menubar icon state).

### 5.4 Menubar Status & Quick Controls
**Description:** Always-visible status and fast actions.

**Requirements**
- Menubar icon with:
  - current mode (On/Off)
  - active preset name
  - quick toggle (On/Off)
  - quick bypass action
- Menubar MUST remain responsive under load.

### 5.5 Onboarding Wizard (Permissions + Quick Setup)
**Description:** Guide users through initial setup.

**Requirements**
- A first-run wizard that:
  1) explains what the app does in plain language,
  2) requests required permissions (with OS-native prompts),
  3) helps choose a preset,
  4) opens the test canvas for validation,
  5) provides a finish screen with bypass instructions.
- Wizard MUST detect missing permissions and show actionable next steps.

### 5.6 Test Canvas (“Feel Check”)
**Description:** A dedicated screen for users to test improvements.

**Requirements**
- Provide a canvas with simple tasks:
  - hover/click small targets
  - trace a line slowly
  - move quickly between targets
- Display current preset and slider setting.
- Provide one-click “Reset to defaults”.

### 5.7 Local Diagnostics (No Telemetry)
**Description:** Provide debug info without uploading.

**Requirements**
- Show:
  - app version
  - macOS version
  - current preset/slider values
  - estimated event rate (Hz)
  - permission status checklist
- Provide “Copy diagnostics” to clipboard (redacted, no PII).

### 5.8 Optional Trace Export (Future Dataset Enabler)
**Description:** User-initiated recording of movement deltas for improvement/debugging.

**Requirements**
- Trace export MUST be **off by default** and initiated by user.
- Recording flow MUST be guided and include three exercises:
  1) Hold steady (5–8s)
  2) Slow tracking (8–12s)
  3) Fast moves (5–8s)
- Export format MUST be a ZIP containing:
  - `session.json` (metadata, no PII)
  - `events.jsonl` (t, dx, dy, dt; optional buttons/wheel)
  - `segments.json` (exercise boundaries)
  - optional `notes.txt` (user-provided)
- The app MUST run quality checks and warn if the trace is unusable.
- The app MUST present a privacy statement at export time.

**Explicit privacy constraints for exports**
- MUST NOT include absolute timestamps, app/window names, screen coordinates, or keystrokes.
- MUST NOT include network identifiers or hardware serial numbers.
- Vendor/product IDs MUST be optional and disabled by default.

---

## 6. User Interaction Flows

### 6.1 First Run / Onboarding
1. Launch app → Welcome screen (plain-language explanation).
2. Permissions screen:
   - show required permissions and “Open System Settings” deep links if possible.
3. Preset selection screen:
   - Light / Balanced (default) / Strong
4. Test Canvas:
   - user performs 2–3 tasks; can toggle On/Off for comparison.
5. Finish screen:
   - shows menubar icon, bypass shortcut, and where to change settings.

**Acceptance criteria**
- Wizard completes with clear status (permissions granted vs missing).
- If permissions are missing, wizard shows explicit remediation steps.

### 6.2 Daily Use
- User toggles On/Off from menubar.
- User holds Precision key to do fine clicks.
- User occasionally adjusts Stability slider (rare).
- User can bypass instantly if something feels wrong.

### 6.3 Trace Export
- Settings → “Help improve filtering” → Start recording.
- App guides through 3 exercises with timers.
- App validates and prompts export location.
- App shows exactly what the export contains + privacy notice.

---

## 7. Functional Requirements (Consolidated)

### FR-1 Stabilization
- MUST provide real-time stabilization using deterministic filtering.
- MUST support presets Light/Balanced/Strong.
- MUST support On/Off toggle and instant bypass.

### FR-2 Controls
- MUST provide a single “Stability ↔ Responsiveness” slider.
- MUST provide Precision Hold activation via a key/button.

### FR-3 UX
- MUST provide onboarding wizard with permission guidance.
- MUST provide menubar control and status.
- MUST provide test canvas.

### FR-4 Diagnostics
- MUST show permission state, event rate, settings.
- MUST allow copying diagnostics (no PII).

### FR-5 Trace Export (Optional)
- MUST be opt-in.
- MUST follow privacy constraints and file schema.

---

## 8. Non-Functional Requirements

### 8.1 Performance & Latency
- Filtering MUST process events in real time at up to 1000 Hz input.
- The stabilization pipeline MUST add **minimal perceived latency**; target is “not noticeable” for most users on Balanced.
- CPU usage in idle pointer movement MUST remain within a reasonable bound (implementation target: low single-digit % on modern Macs).

### 8.2 Reliability
- App MUST not crash in typical use.
- App MUST include a “panic disable” safety mechanism:
  - If the app crashes repeatedly on startup (N times), it should start with stabilization disabled and inform the user.

### 8.3 Security & Privacy
- No background network requests required for core functionality.
- No collection of app usage, window titles, or screen positions.
- Trace exports are local files only; user chooses if/where to share.

### 8.4 Accessibility
- UI controls must be accessible via VoiceOver where applicable.
- Large click targets and readable text; avoid dense expert settings in the default view.

### 8.5 Maintainability
- Configuration should be stored in a single, versioned schema.
- Presets are defined in a declarative format to support future changes safely.

---

## 9. Edge Cases and Failure Scenarios

### 9.1 Permissions Not Granted
- Behavior: stabilization cannot run; app shows persistent “Setup required” state.
- Requirement: app MUST not silently fail; must guide user to fix.

### 9.2 Extremely High Polling Rate / Bursty Events
- Behavior: event stream may contain jitter in dt.
- Requirement: filter must be stable under varying dt and not explode (no NaN, no runaway).

### 9.3 Precision Hold Conflicts with User Shortcuts
- Behavior: key conflicts.
- Requirement: allow selecting a different key; provide defaults and reset.

### 9.4 Unintended “Sticky Cursor”
- Behavior: strong smoothing prevents micro adjustments.
- Requirement: slider + presets allow reducing strength quickly; bypass always available.

### 9.5 Drag & Drop Regression
- Behavior: smoothing changes perceived path and can trigger drop issues.
- Requirement: include explicit QA checklist for drag & drop; tune defaults to avoid regressions.

### 9.6 App Crash / Misbehavior
- Requirement: panic disable on repeated launch crash; clear instructions to recover.

---

## 10. Release & Distribution Requirements (v1.0)

- Code signing and notarization for distribution outside Mac App Store (if chosen).
- Clear user instructions for permissions and first run.
- Versioned changelog.
- No auto-updater required for MVP; can be added later if desired.

---

## 11. Future Decision Gate: DriverKit Virtual HID Track (Post-MVP)

**Goal:** consider DriverKit Virtual HID only after proving product-market fit within the assistive niche.

**Entry criteria**
- Sufficient user demand and clearly documented limitations of user-space approach.
- Willingness to handle install friction and entitlement process.

**Non-requirements for v1.0**
- No DriverKit implementation required.

---

## 12. Structured TODO Plan (Execution-Ready)

> Each task includes: **Priority**, **Effort**, **Inputs**, **Process**, **Outputs**, **Acceptance Criteria**, **Verification**.
> Effort is a relative complexity score: **S (small)** / **M (medium)** / **L (large)**.

### Phase A — Product Spec Lock & Repo Setup
| ID | Task | Priority | Effort |
|---|---|---:|---:|
| A1 | Finalize MVP feature list (max 7) | High | S |
| A2 | Define preset behaviors and UX copy (plain-language) | High | S |
| A3 | Create repo structure + docs skeleton | High | S |
| A4 | Define settings schema (versioned) | High | S |

**A1 — Finalize MVP feature list**
- Inputs: This PRD.
- Process: Freeze v1.0 feature list; mark post-1.0 backlog.
- Outputs: `SCOPE.md` with in/out scope.
- Acceptance: No ambiguous “maybe” features remain in v1.0.
- Verification: PR review checklist passes.

### Phase B — Core Stabilization Prototype
| ID | Task | Priority | Effort |
|---|---|---:|---:|
| B1 | Implement event capture pipeline (user-space) | High | L |
| B2 | Implement deterministic filter baseline + presets | High | L |
| B3 | Implement bypass + precision hold | High | M |
| B4 | Create test canvas | High | M |
| B5 | Basic diagnostics panel | Medium | S |

**B2 — Filter baseline + presets**
- Inputs: `(dx, dy, dt)` stream.
- Process: Implement filter module with deterministic mapping for presets and slider.
- Outputs: `FilterCore` module with unit tests and preset definitions.
- Acceptance: Presets produce distinct behavior; no instability with varying `dt`.
- Verification: Unit tests + manual feel tests on canvas.

### Phase C — UX & Onboarding
| ID | Task | Priority | Effort |
|---|---|---:|---:|
| C1 | First-run wizard screens + permission guidance | High | M |
| C2 | Menubar status & quick actions | High | M |
| C3 | Settings UI (presets + slider + precision key) | High | M |
| C4 | Copy diagnostics + troubleshooting page | Medium | S |

### Phase D — Trace Export (Optional but recommended pre-1.0)
| ID | Task | Priority | Effort |
|---|---|---:|---:|
| D1 | Guided recording flow (3 exercises) | Medium | M |
| D2 | Implement ZIP export + schema docs | Medium | M |
| D3 | Quality checks + privacy statement | Medium | S |

### Phase E — QA, Hardening, and Release
| ID | Task | Priority | Effort |
|---|---|---:|---:|
| E1 | Golden manual test checklist (must-work scenarios) | High | S |
| E2 | Crash safety: panic disable on repeated launch issues | High | M |
| E3 | Packaging, signing, notarization docs | High | M |
| E4 | Beta feedback loop (issue templates, triage labels) | Medium | S |

---

## 13. Acceptance Test Checklist (v1.0)

### Functional
- [ ] Toggle On/Off works from menubar.
- [ ] Bypass shortcut disables stabilization instantly.
- [ ] Presets switch immediately and are reflected in UI.
- [ ] Precision Hold activates only while key is held and shows status.
- [ ] Onboarding wizard detects permissions and guides remediation.
- [ ] Test canvas tasks are usable and allow comparing filtered/unfiltered behavior.
- [ ] Diagnostics screen shows accurate permission and event rate info.
- [ ] Trace export produces ZIP with correct schema (when enabled).

### Must-work Scenario Tests
- [ ] Small target clicking.
- [ ] Text selection (slow and moderate speed).
- [ ] Drag & drop (finder).
- [ ] Rapid movement between targets (no “stuck” feeling).

### Safety
- [ ] App recovers after force quit; stabilization can be disabled.
- [ ] Panic disable triggers after repeated crash and informs the user.

---

## 14. Open Questions (Explicit)
> These are the only areas where additional product input may be needed. If unanswered, proceed with defaults.

1. **Distribution target:** GitHub releases only, or also Mac App Store? (Default: GitHub releases + notarization instructions.)
2. **Minimum macOS version:** choose baseline (Default: a recent major macOS version to reduce compatibility overhead.)
3. **Precision Hold key default:** choose a non-conflicting default (Default: a configurable modifier-like option).

---

## 15. Appendix — Trace Export Schema (Reference)

### `session.json` (example)
```json
{
  "app_version": "0.1.0",
  "macos_version": "14.x",
  "device": {"transport": "USB", "vendor_id": null, "product_id": null},
  "filter": {"preset": "Balanced", "stability_responsiveness": 0.55, "precision_hold_multiplier": 1.6},
  "recording": {"duration_ms": 62000, "exercises": ["steady", "slow", "fast"]}
}
```

### `events.jsonl` (example)
```json
{"t":0,"dx":1,"dy":0,"dt":8}
{"t":8,"dx":0,"dy":-1,"dt":8}
{"t":16,"dx":2,"dy":1,"dt":8}
```

### `segments.json` (example)
```json
[
  {"name":"steady","t_start":0,"t_end":7000},
  {"name":"slow","t_start":7000,"t_end":23000},
  {"name":"fast","t_start":23000,"t_end":32000}
]
```

---

**End of PRD**
