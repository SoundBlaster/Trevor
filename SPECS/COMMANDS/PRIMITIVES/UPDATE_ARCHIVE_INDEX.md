# UPDATE-ARCHIVE-INDEX — Refresh Archive Index (Trevor)

**Version:** 2.0
**Project:** Trevor Mouse Tremor Filter (W0 Web Tools + P0-P6 macOS phases)

## Purpose

Keep `SPECS/TASKS_ARCHIVE/INDEX.md` in sync with newly archived tasks by inserting their entries under the correct phase (W0, P0-P6), updating statistics, and preserving historical metadata.

## Usage

1. **Identify phase** of archived task:
   - W0.x → Web Tools section
   - P0.x → Foundation section
   - P1.x → FilterCore section
   - P2.x → Event Pipeline section
   - P3.x → Application UI section
   - P4.x → Safety & Reliability section
   - P5.x → Trace Export section
   - P6.x → QA & Release section

2. **Open `SPECS/TASKS_ARCHIVE/INDEX.md`** and locate the corresponding phase section

3. **Add entry** with format:
   ```markdown
   - [✓ 2026-01-12] W0.2 — Pointer Stabilization Playground
     - Link: [PRD](./W0.2_Playground.md) | [Summary](./W0.2-Playground-summary.md)
     - Effort: Medium | Depends: P1.2 (FilterCore)
     - Notes: First marketing surface, <16ms frame time achieved
   ```

4. **Update statistics** at bottom of INDEX.md:
   - Increase **Total Archived Tasks** by one
   - Add effort to **Total Effort** (if tracking)
   - Update **Phases Represented** line
   - Update **Last Updated** timestamp

## Guidelines

- **Maintain chronological order** within each phase (newer → older, top to bottom)
- **Preserve separator blocks** (`---`) between phase sections
- **Use task ID + name** from Workplan.md for consistency
- **Include phase header** if first task for that phase:
  ```markdown
  ## W0 — Web Tools

  [Tasks here]

  ---
  ```
- **Link format:** Relative links to PRD and summary in same TASKS_ARCHIVE/ directory
- **Track completion date** in format `[✓ YYYY-MM-DD]`

## Example Entry

```markdown
## W0 — Web Tools

- [✓ 2026-01-12] W0.2 — Pointer Stabilization Playground
  - Links: [PRD](./W0.2_Playground.md) | [Summary](./W0.2-Playground-summary.md)
  - Effort: Medium (depends on P1.2)
  - Tests: Jest suite, <16ms frame time ✓
  - Notes: TS port of FilterCore, interactive canvas, preset selector

---

## P1 — FilterCore (Critical Path)

- [✓ 2026-01-10] P1.2 — Implement One Euro Filter
  - Links: [PRD](./P1.2_FilterCore.md) | [Summary](./P1.2-FilterCore-summary.md)
  - Effort: High (core algorithm)
  - Tests: XCTest, 23 unit tests ✓, <0.5ms latency ✓
  - Notes: Shared with W0.2 (TS port), stable under variable dt ✓

---
```

## Phase Order (for INDEX.md structure)

```
W0 — Web Tools
---
P0 — Foundation
---
P1 — FilterCore
---
P2 — Event Pipeline
---
P3 — Application UI
---
P4 — Safety & Reliability
---
P5 — Trace Export
---
P6 — QA & Release
---
```

## Statistics Block (at bottom of INDEX.md)

```markdown
## Archive Statistics

- **Total Archived Tasks:** N
- **Total Effort:** X hours
- **Phases Represented:** W0, P0, P1, P2 (4/8)
- **Last Updated:** 2026-01-12
- **Critical Path Complete:** P0 ✓, P1 ✓, P2 ✓, P3 ✗, P4 ✗, P6 ✗
```
