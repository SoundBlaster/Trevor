# Mouse Tremor Filtering for macOS — Product Roadmap (DriverKit-ready, ML-out-of-scope)

**Project type:** non-commercial / assistive tech / open-source-friendly  
**Primary goal:** noticeably reduce high‑frequency pointer jitter (tremor) while keeping cursor control **predictable** and **low-latency**.

---

## 1. Vision & Success Criteria

### Vision
Enable comfortable, reliable pointer control on macOS for people affected by tremor—without forcing them to change their workflows.

### North-star metric
**“Stability without rubber-band.”** Users report that fine targeting becomes easier **without** feeling sluggish or delayed.

### Success criteria (v1.0)
- Users can **hit small UI targets** and perform **text selection** more reliably.
- Fast motions remain responsive; no “sticky cursor” complaints dominating feedback.
- Setup is understandable for non-technical users (or caregivers).
- Always-on safety: **instant bypass** is available.

---

## 2. Target Users & Primary Scenarios

### Target users
- People with essential tremor / Parkinson’s / MS / other motor impairments.
- Caregivers / family members configuring the Mac for someone else.
- Therapists / rehab specialists (secondary).

### Must-work scenarios
1. Precise pointing (small icons, close buttons, sliders).
2. Text selection.
3. Drag & drop (finder, rearranging items).
4. General navigation (menus, scrolling).

### Nice-to-have later
- Creative tools (drawing, photo editing).
- Special app/game modes (likely out-of-scope early).

---

## 3. Product Principles (Guardrails)

1. **Presets first**: simple choices beat complex tuning.
2. **Explainability**: every control maps to a human concept (e.g., “Stability vs Responsiveness”).
3. **Always reversible**: one-click + hotkey **bypass**.
4. **Local-first**: no background telemetry. Data export is user-initiated.
5. **Compatibility over cleverness**: deterministic filtering baseline before any advanced ideas.

---

## 4. Non-goals (for now)

- **No ML-based filtering** in early versions (only deterministic filters).  
  *Reason:* reliability, latency, and data requirements.
- No medical claims (assistive tool, not treatment).
- No “recording user behavior”: no app names, window titles, or screen coords collection.

---

## 5. Roadmap Phases

> Each phase is defined by **Goals**, **Deliverables**, **Definition of Done (DoD)**, and **Risks**.

### Phase 0 — Product Definition & Validation
**Goal:** lock the MVP scope and validate the pain points.

**Deliverables**
- One-page PRD-lite: problem → audience → must-work scenarios → success criteria.
- 10–20 short user inputs (messages/interviews), including “what’s hardest” tasks.
- Public statement of privacy stance (local-first, optional export).

**DoD**
- MVP scope fixed (max 5–7 user-facing features).
- Clear “out of scope” list to prevent drift.

**Risks**
- Overfitting to power-user expectations; missing caregiver-friendly UX.

---

### Phase 1 — MVP Prototype (No DriverKit)
**Goal:** prove the filtering **feels right** before investing in DriverKit entitlements and distribution complexity.

**MVP features**
- Toggle: On/Off + “Bypass” hotkey.
- Presets: **Light / Balanced / Strong**.
- **Precision Hold**: hold a key/button to temporarily increase stability (or reduce speed).
- “Test Canvas” screen: immediate **before/after** feel check.
- Basic diagnostics panel (local only).

**Deliverables**
- macOS app prototype with guided setup for required permissions.
- Short demo video / GIF showing improvement (test canvas).
- Known limitations list.

**DoD**
- At least 10–20 users report meaningful improvement in at least one must-work scenario.
- At least one preset is widely “comfortable” (low complaint rate about sluggishness).
- Instant bypass works reliably.

**Risks**
- A filter that is mathematically “good” but subjectively annoying.
- Permissions/setup friction causing drop-off.

---

### Phase 2 — UX Hardening & Accessibility-first Design
**Goal:** turn the MVP into something a non-technical user can install and configure confidently.

**Deliverables**
- First-run wizard: permissions → pick preset → test → finish.
- Status indicator (menu bar): On/Off/Precision.
- Simple settings:
  - Main slider: **Stability ↔ Responsiveness**
  - Optional: “Micro‑aim assistance”
- Help/FAQ (permissions, known issues, troubleshooting).
- Localization-ready structure (even if only English initially).

**DoD**
- “Cold install” can be completed without developer help.
- Support burden is primarily “permissions issues”, not “what do the controls mean?”

**Risks**
- UX too technical; users abandon after install.
- Too many knobs = confusion.

---

### Phase 3 — Optional Dataset Path (Local Export Only)
**Goal:** enable future improvements by letting early users **voluntarily** export high-quality traces.

**Key idea:** **no automatic upload**. User chooses when to record, export, and share.

**Deliverables**
- Guided “Record Trace” flow (30–90s total):
  1) **Hold steady** (5–8s)
  2) **Slow tracking** (8–12s)
  3) **Fast moves** (5–8s)
- Export as ZIP containing:
  - `session.json` (metadata, no PII)
  - `events.jsonl` (t, dx, dy, dt, optional buttons/wheel)
  - `segments.json` (exercise boundaries)
  - optional `notes.txt` (user-provided)
- Built-in quality checks before export:
  - minimum duration
  - event-rate sanity
  - exercises completed

**DoD**
- Export works offline; file is readable and documented.
- Privacy statement is shown at export time and is accurate:
  - no absolute timestamps
  - no app/window names
  - no screen coordinates
  - no text capture

**Risks**
- Over-collection (creepy) → user trust loss.
- Under-collection (useless) → dataset unusable.

---

### Phase 4 — Decision Gate: DriverKit Virtual HID Track
**Goal:** decide whether to invest into DriverKit Virtual HID for deeper system integration.

**Decision inputs**
- Active user base and consistent demand.
- A concrete list of MVP limitations that *DriverKit solves* (not “sounds better”).

**If YES (Virtual HID track)**
**Deliverables**
- DriverKit System Extension (Dext) that exposes a virtual mouse.
- Companion app handles:
  - reading physical device events
  - applying deterministic filter
  - forwarding stabilized events to virtual device
- Installer flow using SystemExtensions (user approvals + notarization approach).

**DoD**
- Virtual mouse is stable across reboots and common devices.
- Fallback: user can revert to non-DriverKit mode or bypass instantly.
- Release checklist (signing/notarization/permissions) documented.

**Risks**
- Entitlements approval, distribution friction, OS updates affecting behavior.
- Support load increases due to install complexity.

**If NO**
- Continue refining non-DriverKit approach and UX; focus on accessibility and presets.

---

### Phase 5 — Public Beta & Community Ops
**Goal:** scale feedback, reduce regressions, and make the project sustainable.

**Deliverables**
- Issue templates: bug report, “filter feels wrong”, device compatibility.
- “Golden manual test plan” for must-work scenarios.
- Minimal release notes discipline (what changed, who it helps, what may break).
- Optional anonymized “diagnostics bundle” export (still local-first).

**DoD**
- Triage process established: label + reproduce + confirm fix.
- Regression rate drops; user trust improves.

**Risks**
- Too many device-specific reports without a reproducible harness.
- Maintainer burnout; need contributors (docs/triage).

---

### Phase 6 — v1.0 Release (Assistive Tool)
**Goal:** deliver a stable, understandable tool that can be recommended.

**Deliverables**
- Polished onboarding + defaults that “just work” for many.
- Safety features:
  - always accessible bypass
  - “panic switch” (disable on startup if last session crashed)
- Documentation:
  - how it works (high level)
  - privacy stance
  - troubleshooting
- Clear licensing & governance (CONTRIBUTING, CODE_OF_CONDUCT).

**DoD**
- New users can succeed without reading deep docs.
- The project can be maintained via community input.

**Risks**
- Packaging and permissions remain the #1 blocker—must keep onboarding excellent.

---

## 6. Feature Backlog (Post-1.0 Ideas)

- Per-app profiles (optional; must not leak app usage in exports).
- Axis-specific tuning (X/Y), advanced deadzone, and jerk limiting.
- Better scroll stabilization (separate pipeline from pointer).
- Caregiver mode: “lock settings” with simple UI.
- Research mode (opt-in): structured trace export for studies (still local-first).

---

## 7. Appendix — Trace Export Schema (Minimal)

### `session.json` (example)
```json
{
  "app_version": "0.3.0",
  "macos_version": "14.6",
  "device": {
    "transport": "USB",
    "vendor_id": null,
    "product_id": null
  },
  "filter": {
    "preset": "Balanced",
    "stability_responsiveness": 0.55,
    "precision_hold_multiplier": 1.6
  },
  "recording": {
    "duration_ms": 62000,
    "exercises": ["steady", "slow", "fast"]
  }
}
```

### `events.jsonl` (example lines)
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

## 8. Next Step (from this document)
Pick one:
1. **MVP Scope Lock**: finalize 5–7 features + Definition of Done.
2. **UX Flow Draft**: onboarding screens, controls, and copy.
3. **Technical Plan**: event capture approach, filter baseline, and future DriverKit branch.

