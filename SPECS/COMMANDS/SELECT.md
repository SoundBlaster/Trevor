# SELECT — Next Task Selection (Trevor: Mouse Tremor Filter)

**Version:** 2.0.0
**Project:** Trevor Mouse Tremor Filter (W0 Web Tools + P0-P6 macOS phases)

## Purpose

SELECT identifies the next task from Workplan.md based on priorities, dependencies, and parallelization rules. It does **NOT** create implementation plans - that's the job of the PLAN command.

## Input
- `SPECS/PRD/Workplan.md` — master work plan (W0 + P0-P6 phases)
- `SPECS/INPROGRESS/next.md` — current task (if any)

## Algorithm

1. **Find candidates** satisfying all:
   - Not completed `[ ]` in COMBINED_Workplan
   - All dependencies satisfied
   - Highest priority (P0 > P1 > P2 > P3 > P4 > P5 > P6; W0 fully parallel)
   - On critical path (if tie)
   - Sequential order (if tie)

2. **Parallelization Rules:**
   - W0 (Web Tools) is fully parallel to P0-P6 (macOS)
   - P1 → P2 → P3 → P4 → P6 sequential (blocking chain)
   - P5 (Trace Export) parallel to P3/P4
   - If W0 and macOS both available, prefer critical path (P0-P4) but suggest W0 for parallel work

3. **Create minimal** `next.md` with ONLY:
   - Task ID and phase: `# Next Task: {PHASE_ID}.{TASK_ID} — {TASK_NAME}`
   - Basic metadata: Track (W0 or macOS), Priority, Effort, Dependencies
   - Brief description (1-2 sentences)
   - Parallelization note if applicable (e.g., "Can run parallel to P3.x")
   - Status: "Selected"

4. **Update Workplan.md** with `**INPROGRESS**` marker

## Output
- Updated `SPECS/INPROGRESS/next.md` (minimal metadata only)
- Updated `SPECS/PRD/Workplan.md` with progress markers

## next.md Template (Minimal)

```markdown
# Next Task: W0.2 — Pointer Stabilization Playground

**Track:** Web Tools (W0)
**Priority:** High
**Effort:** Medium (P0.2 FilterCore ported to TS required)
**Dependencies:** P1.2 (FilterCore implementation in Swift)
**Parallelizable:** ✓ Yes, after P1.2 complete
**Status:** Selected

## Description

Interactive HTML5 canvas playground demonstrating raw vs. filtered pointer paths with preset selector and stability slider. First marketing surface for web demo.

## Context

- Depends on FilterCore algorithm ported to TypeScript (from P1.2)
- Part of W0 (Web Tools) track, runs parallel to macOS phases
- Used for early validation and dataset collection
- Enables demo without requiring Apple hardware

## Next Step

Run PLAN command to generate detailed PRD with test cases from TestPlan.md:
$ claude "Выполни команду PLAN"
```

**IMPORTANT:** Do NOT add:
- Detailed checklists
- Acceptance criteria
- Implementation steps
- Code examples or templates

These belong in the PRD created by PLAN command.

## Exceptions
- **No available tasks** → Exit with verbose error (all phases complete?)
- **Multiple P0 tasks** → Select first on critical path (blockers)
- **W0 vs macOS tie** → Recommend parallel (both, if resources allow)
- **Dependencies blocked** → Skip until dependency complete, suggest next available

