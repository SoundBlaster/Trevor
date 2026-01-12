# PLAN — Generate PRD from Task (Trevor: Mouse Tremor Filter)

**Version:** 2.0.0
**Project:** Trevor Mouse Tremor Filter (W0 Web Tools + P0-P6 macOS phases)

## Input
- `SPECS/INPROGRESS/next.md` — current task (from SELECT)
- `SPECS/PRD/Workplan.md` — task context, phase, dependencies
- `SPECS/PRD/TestPlan.md` — test requirements for task's phase
- `SPECS/RULES/01_PRD_PROMPT.md` — PRD generation rules
- `SPECS/PRD/[design specs]` — project architecture/algorithms

## Algorithm

1. **Extract task** from `next.md` (Phase.ID, name, track)
2. **Gather context** from `Workplan.md`:
   - Phase (W0.x or P0.x-P6.x)
   - Priority, track (Web or macOS)
   - Dependencies, parallelization notes
   - Related tasks in same phase

3. **Extract test cases** from `TestPlan.md`:
   - Find section matching task's phase
   - Copy relevant automated tests, manual tests, acceptance criteria
   - Include performance benchmarks if applicable (P1.7, P6.3)

4. **Apply rules** from `01_PRD_PROMPT.md`:
   - Task breakdown structure
   - Acceptance criteria format
   - Quality checklist
   - Implementation templates

5. **Generate** `SPECS/INPROGRESS/{PHASE_ID}_{TASK_NAME}.md` with:
   - Task overview + context
   - Detailed task breakdown (from COMBINED_Workplan)
   - Test cases + acceptance criteria (from TestPlan)
   - Quality checklist
   - Implementation templates (code stubs, configs, etc.)

## Output
- PRD file at `SPECS/INPROGRESS/{PHASE_ID}_{TASK_NAME}.md`

**Example outputs:**
- `SPECS/INPROGRESS/W0.2_Playground.md` (web track)
- `SPECS/INPROGRESS/P1.2_FilterCore.md` (macOS FilterCore)
- `SPECS/INPROGRESS/P3.1_Settings.md` (macOS UI)

## Exceptions
- **No task in next.md** → Exit with verbose error: "Run SELECT first"
- **Task not in COMBINED_Workplan** → Exit with verbose error
- **TestPlan missing tests for phase** → Warn but proceed (manual enrichment needed)
- **PRD exists** → Use --overwrite or --append
- **Insufficient context** → List what's missing, request manual enrichment
