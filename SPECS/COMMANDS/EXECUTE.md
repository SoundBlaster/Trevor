# EXECUTE — Execute Current Task (Trevor: Mouse Tremor Filter)

**Version:** 2.1.0
**Project:** Trevor Mouse Tremor Filter (W0 Web Tools + P0-P6 macOS phases)

## Purpose

Provide a **thin workflow wrapper** around task execution for both web and macOS development. This command:
1. Performs pre-flight checks (git clean, dependencies satisfied, toolchains installed)
2. Displays the implementation plan from PRD + relevant test cases from TestPlan
3. **[DEVELOPER/CLAUDE DOES THE ACTUAL WORK]**
4. Validates results against TestPlan acceptance criteria
5. Updates progress markers and commits

**Important:** EXECUTE is NOT an AI agent that implements code automatically. It's a structured checklist runner that automates the workflow **around** implementation.

## Critical Validation Requirements

### For Web Tools (W0) Tasks:
- **Node.js + npm** required for web tests
- After code changes, validation MUST run:
  ```bash
  npm test          # Run Jest tests
  npm run build     # Build TypeScript/bundler
  ```

### For macOS (P0-P6) Tasks:
- **Swift must be installed before starting EXECUTE.** If missing, run INSTALL_SWIFT first: **[`PRIMITIVES/INSTALL_SWIFT.md`](./PRIMITIVES/INSTALL_SWIFT.md)**
- After code changes, validation MUST run:
  ```bash
  ./.github/scripts/restore-build-cache.sh  # Optional: speed up builds
  swift test 2>&1   # Run XCTest + build
  ```

- Do NOT commit code that doesn't compile or has failing tests
- If Swift or cache unavailable, note explicitly in commit message

## Philosophy

All implementation instructions exist in:
- **Workplan.md** — phase context, dependencies, parallelization
- **TestPlan.md** — step-by-step test procedures, acceptance criteria
- **PRD** — atomic task breakdown, acceptance criteria per subtask
- **Design Specs** — architecture, algorithms (FilterCore One Euro filter, etc.)

EXECUTE simply:
- Checks prerequisites + toolchains
- Shows plan + test requirements
- Lets you work
- Validates against tests (web or macOS or both)
- Commits and updates documentation

---

## Input

- `SPECS/INPROGRESS/next.md` — current task (extract PHASE_ID.TASK_ID)
- `SPECS/INPROGRESS/{PHASE_ID}_{TASK_NAME}.md` — PRD with implementation plan
- `SPECS/PRD/Workplan.md` — phase context, parallelization
- `SPECS/PRD/TestPlan.md` — test cases and acceptance criteria for phase

---

## Algorithm

### Phase 1: Pre-Flight Checks

**Purpose:** Ensure environment is ready for work (web and/or macOS)

1. **Determine task track and install required toolchains:**
   ```bash
   # Extract track from next.md (W0 or macOS P0-P6)
   TASK_PHASE=$(head -1 SPECS/INPROGRESS/next.md | grep -oE "^W0|P[0-6]")

   if [[ $TASK_PHASE == "W0"* ]]; then
     # Web Tools (W0) — require Node.js + npm
     which node && npm --version
     [ $? -ne 0 ] && echo "Node.js/npm required for web tools. Install first."
   else
     # macOS (P0-P6) — require Swift
     swift --version || run PRIMITIVES/INSTALL_SWIFT.md
   fi
   ```

2. **Verify Git state:**
   ```bash
   git status --porcelain
   # Must be empty (no uncommitted changes)
   ```

3. **Load task context:**
   ```bash
   PHASE_ID=$(head -1 SPECS/INPROGRESS/next.md | grep -oE "^[WP][0-6].*[^—]" | cut -d' ' -f1)
   TASK_NAME=$(head -1 SPECS/INPROGRESS/next.md | sed 's/# Next Task: .* — //')
   PRD="SPECS/INPROGRESS/${PHASE_ID}_*.md"
   ```

4. **Check dependencies:**
   - Read `Dependencies:` line from next.md
   - Verify all upstream tasks marked `[x]` in Workplan.md
   - **Exit if dependencies not satisfied**

5. **Verify PRD exists:**
   - Check `SPECS/INPROGRESS/{PHASE_ID}_*.md` exists
   - **Exit if not found:** "Run PLAN command first"

6. **Load test requirements from TestPlan:**
   - Find section in TestPlan.md matching PHASE_ID (e.g., "2.1 FilterCore Tests" for P1)
   - Extract automated tests, manual golden tests, acceptance criteria
   - Display relevant test cases that will be run during post-flight

7. **Display plan summary:**
   ```
   ╔════════════════════════════════════════════════════════════╗
   ║  EXECUTE: {PHASE_ID}.{TASK_NAME}                          ║
   ║  Track: {W0 Web Tools | macOS P0-P6}                      ║
   ╚════════════════════════════════════════════════════════════╝

   📋 Task: {PHASE_ID} — {TASK_NAME}
   📄 PRD: SPECS/INPROGRESS/{PHASE_ID}_{TASK_NAME}.md
   🧪 Tests: [Reference TestPlan.md section X.Y]
   🔗 Dependencies: {LIST or "None"}

   📝 Implementation Plan:
   - Subtask 1: {NAME} ({CONTEXT})
   - Subtask 2: {NAME} ({CONTEXT})
   - [...]

   ✅ Test Cases: {COUNT} (from TestPlan.md)
   ✅ Acceptance Criteria: {COUNT} items
   ```

8. **Prompt user:**
   ```
   Ready to execute {PHASE_ID}?
   - PRD contains all implementation instructions
   - TestPlan.md contains all test requirements
   - Acceptance criteria tied to tests

   After implementation:
   {Track-specific tests will run}

   [Enter] to continue, [Ctrl+C] to abort
   ```

---

### Phase 2: Work Period

**[THIS IS WHERE DEVELOPER/CLAUDE WORKS]**

The PRD contains everything needed:
- **Implementation templates** (e.g., Package.swift, main.swift)
- **Step-by-step instructions** per subtask
- **Acceptance criteria** to validate each step
- **Verification commands** (e.g., swift build, swift test)

**Developer works by:**
1. Reading PRD §2 "Hierarchical Task Breakdown"
2. Following instructions for each subtask
3. Using templates from PRD §8 "Implementation Template"
4. Testing against acceptance criteria from PRD §3.3

**Optional: Interactive Progress Tracking**

If `--interactive` mode:
- Periodically prompt: "Mark completed subtasks? [y/n]"
- Show checklist from next.md
- User marks `[ ]` → `[x]` for completed items
- Update progress percentage
- Continue work

**Note:** This is optional. Developer can manually update next.md checklist anytime.

---

### Phase 3: Post-Flight Validation

**Purpose:** Verify implementation meets requirements (TestPlan-driven)

**CRITICAL:** Validation commands depend on task track (Web vs. macOS)

#### For Web Tools (W0) Tasks:

1. **Run Jest tests:**
   ```bash
   npm test --passWithNoTests 2>&1
   ```

   **If tests fail:**
   - Fix all failing tests before proceeding
   - Do NOT commit code with failing tests
   - Re-run `npm test` until all pass

2. **Build check:**
   ```bash
   npm run build 2>&1
   ```

   **If build fails:**
   - Fix all compilation/bundler errors
   - Re-run `npm run build` until it succeeds

3. **Performance check (if applicable to phase):**
   - For W0.2 Playground: Verify <16ms frame time
   - Run: `npm run perf` (if defined in package.json)

4. **Collect results:**
   ```
   Web Tools Validation (W0):
   [✓] npm test — PASS (N tests passed)
   [✓] npm run build — PASS (0 errors)
   [✓] Performance — PASS (<16ms frame time)

   Status: READY TO COMMIT
   ```

#### For macOS (P0-P6) Tasks:

1. **OPTIONAL: Restore build cache for faster compilation:**
   ```bash
   # Speeds up compilation from 82s to ~5-10s (8-16x faster)
   ./.github/scripts/restore-build-cache.sh
   ```

   **Notes:**
   - Safe to skip if cache not available — build will work normally
   - After successful build: `./.github/scripts/create-build-cache.sh`

2. **MANDATORY: Run Swift tests:**
   ```bash
   ./.github/scripts/restore-build-cache.sh  # Optional speedup
   swift test 2>&1
   ```

   **If `swift test` (build + tests) fails:**
   - Fix all compilation errors or failing tests
   - Do NOT commit code that doesn't compile
   - Re-run `swift test` until all pass

3. **Extract verification commands from PRD:**
   - Parse "Acceptance Criteria per Task" section
   - Find additional validation commands (e.g., performance benchmarks)

4. **Run performance tests (if applicable to phase):**
   - P1.7: FilterCore micro-benchmarks — `swift run benchmark-filter`
   - P6.3: Performance profiling — `instruments` (manual or scripted)

5. **Collect results:**
   ```
   macOS Validation (P1 example):
   [✓] swift test — PASS (23 tests passed, 0 failures)
   [✓] swift build — PASS (0 errors, 0 warnings)
   [✓] FilterCore latency — PASS (<0.5ms per sample)
   [✓] No NaN/Inf output — PASS (invariants verified)

   Quality Checklist:
   [✓] Unit tests cover all code paths
   [✓] Performance benchmarks met
   [✓] No compiler warnings

   Status: READY TO COMMIT
   ```

#### Common Validation Steps (Both Tracks):

6. **Run git diff to confirm expected changes:**
   ```bash
   git diff --stat HEAD
   ```

7. **Generate completion report:**
   ```
   ╔════════════════════════════════════════════════════════════╗
   ║  VALIDATION REPORT: {PHASE_ID}_{TASK_NAME}                ║
   ║  Track: {Web Tools (W0) | macOS (P0-P6)}                  ║
   ╚════════════════════════════════════════════════════════════╝

   Implementation: COMPLETE
   Tests: PASS ✓
   Acceptance Criteria: {X/Y} passed
   Build: PASS ✓

   Status: READY TO COMMIT
   ```

8. **If validation fails:**
   ```
   ✗ VALIDATION FAILED

   Failed checks:
   - npm test → {N} failures
   - Performance → Frame time {X}ms (target: <16ms)

   Fix issues and re-run: claude "EXECUTE: validate only"
   ```

---

### Phase 4: Finalization

**Purpose:** Update documentation and commit

1. **Update next.md:**
   - Mark task complete: add `**Status:** ✅ Completed on {DATE}`
   - Mark all subtask checklist items `[x]`
   - Add completion timestamp
   - Note: Don't delete next.md, just mark complete (SELECT creates new one for next task)

2. **Update Workplan.md:**
   - Find task by phase ID (e.g., `### W0.2:` or `### P1.2:`)
   - Mark as completed: `- [x]` instead of `- [ ]`
   - Remove `**Status:** INPROGRESS`
   - Update progress in phase header if applicable

3. **Save task summary (if applicable):**
   - **IMPORTANT:** Task summaries must be saved in `SPECS/INPROGRESS/` folder
   - File naming: `{PHASE_ID}-{TASK_NAME}-summary.md` (e.g., `W0.2-Playground-summary.md`, `P1.2-FilterCore-summary.md`)
   - Include: subtasks completed, acceptance criteria verification, test results, key findings, deliverables, next task suggestions
   - This is a comprehensive report complementing the PRD and test results

4. **Auto-detect deliverables:**
   ```bash
   # Files created/modified during task implementation
   git diff --name-status HEAD
   ```

5. **Create commit:**
   Follow the lightweight checklist in [`SPECS/COMMANDS/PRIMITIVES/COMMIT.md`](./PRIMITIVES/COMMIT.md) to stage and record the changes before pushing.

6. **Push to remote:**
   ```bash
   git push -u origin $(git rev-parse --abbrev-ref HEAD)
   ```

7. **Suggest next action:**
   ```
   ✅ Task {PHASE_ID} completed successfully!

   🎯 Next steps:
   1. Run SELECT to choose next task (W0 or P0-P6)
      $ claude "Выполни команду SELECT"

   2. Or ARCHIVE completed tasks if multiple done
      $ claude "Выполни команду ARCHIVE"

   3. Or create a PR if phase complete
      $ gh pr create --title "Complete Phase {Phase_Name}"
   ```

---

## Execution Modes

### Mode 1: Full (default)

Pre-flight → Work → Post-flight → Finalize

```bash
$ claude "Выполни команду EXECUTE"
```

**Use case:** Standard workflow for any task

---

### Mode 2: Show Plan Only

Only pre-flight checks and plan display

```bash
$ claude "EXECUTE: show plan"
$ claude "Show execution plan for current task"
```

**Use case:** Preview task before starting work

**Output:** Plan summary, no git checks

---

### Mode 3: Validate Only

Skip pre-flight, only run validation and finalization

```bash
$ claude "EXECUTE: validate and commit"
$ claude "Validate current task and commit"
```

**Use case:** After manual implementation, validate and commit

**Flow:**
- Assumes work already done
- Runs acceptance tests
- Creates commit if validation passes

---

### Mode 4: With Progress Tracking

Full mode + periodic progress prompts

```bash
$ claude "EXECUTE with progress tracking"
```

**Use case:** Long tasks (>2 hours), want checkpoints

**Flow:**
- Shows plan
- Developer works
- Every N minutes: "Update progress? [y/n]"
- Runs validation
- Commits

---

## Example Output

```
$ claude "Выполни команду EXECUTE"

╔════════════════════════════════════════════════════════════╗
║  EXECUTE: A1 — Project Initialization                      ║
╚════════════════════════════════════════════════════════════╝

📋 Task: A1 — Project Initialization
📄 PRD: DOCS/INPROGRESS/A1_Project_Initialization.md
⏱️  Estimated: 2 hours
🔗 Dependencies: None (entry point)

─────────────────────────────────────────────────────────────

✓ Pre-Flight Checks:
  [✓] Git working tree clean
  [✓] PRD exists
  [✓] Dependencies satisfied (none required)
  [✓] Task not already complete

📝 Plan Overview:
  Phase 1: Directory Structure (2 subtasks, 30 min)
  Phase 2: Package Configuration (8 subtasks, 1 hour)
  Phase 3: Verification (3 subtasks, 30 min)

  Total: 13 subtasks across 3 phases

📋 Key Acceptance Criteria:
  • swift build completes without errors
  • All 6 module directories created
  • All 3 dependencies resolved
  • Empty test suite runs successfully

─────────────────────────────────────────────────────────────

Ready to execute A1 — Project Initialization?

The PRD contains:
• Implementation templates (Package.swift in §8.1)
• Step-by-step instructions (§2 Task Breakdown)
• Acceptance criteria (§3.3 per subtask)
• Quality checklist (§7.4 validation)

Press [Enter] to continue, [Ctrl+C] to abort: ▊

─────────────────────────────────────────────────────────────

[YOU WORK ON THE TASK FOLLOWING PRD]

... (time passes) ...

─────────────────────────────────────────────────────────────

Running validation...

✓ Acceptance Tests:
  [✓] swift package resolve — PASS (3 dependencies)
  [✓] swift build — PASS (0 errors)
  [✓] swift test — PASS (0 tests)
  [✓] Directory structure — PASS (13 dirs exist)
  [✓] Package.swift dependencies — PASS (all present)

✓ Quality Checklist (PRD §7.4):
  [✓] All 6 source module directories exist
  [✓] All 7 test module directories exist
  [✓] Package.swift contains all 3 dependencies
  [✓] Package.swift defines all 6 module targets
  [✓] CLI as executableTarget
  [✓] All test targets defined
  [✓] No compiler warnings

╔════════════════════════════════════════════════════════════╗
║  VALIDATION REPORT                                         ║
╚════════════════════════════════════════════════════════════╝

Subtasks: 13/13 completed (100%)
Acceptance: 5/5 passed (100%)
Quality: 7/7 verified (100%)

Build: PASS ✓
Tests: PASS ✓

Status: ✅ READY TO COMMIT

─────────────────────────────────────────────────────────────

Finalizing...

✓ Updated next.md (marked complete)
✓ Updated Workplan.md (marked [x] A1)
✓ Created commit: "Complete A1 — Project Initialization"
✓ Pushed to remote: claude/execute-plan-command-015km...

─────────────────────────────────────────────────────────────

✅ Task A1 completed successfully!

🎯 Next steps:
   $ claude "Выполни команду SELECT"

   (Will choose A2: Core Types Implementation)
```

---

## Error Handling

### Pre-Flight Failures

**Git not clean:**
```
✗ Pre-flight check failed: Git working tree not clean

Uncommitted changes:
  M SPECS/PRD/Workplan.md
  ?? new_file.swift

Fix: Commit or stash changes, then retry
```

**Toolchain not installed:**
```
✗ Pre-flight check failed: Required toolchain missing

Task W0.2 (Web Tools) requires: Node.js + npm
  Current: npm not found

Fix: Install Node.js/npm first, or run INSTALL primitive

---

Task P1.2 (macOS) requires: Swift compiler
  Current: Swift version not found

Fix: Run INSTALL_SWIFT first
     $ claude "Run PRIMITIVES/INSTALL_SWIFT"
```

**Dependencies not met:**
```
✗ Pre-flight check failed: Dependencies not satisfied

Task P1.2 requires:
  [x] P0.2 — Finalize specs ✓
  [ ] P1.1 — Define FilterCore API ✗

Fix: Complete P1.1 first or update COMBINED_Workplan dependencies
```

**No PRD:**
```
✗ Pre-flight check failed: PRD not found

Expected: SPECS/INPROGRESS/P1.2_FilterCore.md

Fix: Run PLAN command first
     $ claude "Выполни команду PLAN"
```

---

### Validation Failures

**Web Tools build errors:**
```
✗ Validation failed: npm run build

Build errors:
  src/filter.ts:42: error TS2345 'foo' is not assignable to type 'number'
  src/playground.tsx:15: error: JSX element must be closed

Fix issues and re-run validation:
  $ claude "EXECUTE: validate only"
```

**Web Tools test failures:**
```
✗ Validation failed: npm test

Test failures:
  ● Playground canvas tests › should render preset selector
    Expected: toBeInTheDocument()
    Received: null

  ● Performance tests › frame rate must be <16ms
    Expected: < 16
    Received: 24

Fix tests and re-run:
  $ npm test
  $ claude "EXECUTE: validate only"
```

**macOS build errors:**
```
✗ Validation failed: swift build

Build errors:
  Sources/Core/Filter.swift:47: error: use of unresolved identifier 'normalize'
  Sources/Event/Injection.swift:23: error: missing return

Fix issues and re-run validation:
  $ claude "EXECUTE: validate only"
```

**macOS test failures:**
```
✗ Validation failed: swift test

Test failures:
  FilterCoreTests.FilterCore_NaNInvariant: XCTAssertFalse failed
    - Output contains NaN (invalid numerical stability)

  EventPipelineTests.EventInjection_Latency: XCTAssertLessThan failed
    - Latency 2.5ms (target: <2.0ms)

Fix tests and re-run:
  $ swift test
  $ claude "EXECUTE: validate only"
```

**Acceptance criteria not met (from TestPlan):**
```
✗ Validation failed: 3/5 acceptance criteria not met

Failed (from TestPlan.md):
  [✗] FilterCore latency < 0.5ms per sample
      → Measured: 0.8ms (P1.7 requirement)
  [✗] No NaN/Inf output under variable dt
      → Found: Inf under dt=0 edge case
  [✗] Presets feel distinct
      → Subjective, needs manual verification

Fix issues and update tests, then retry
```

---

## Safety Features

1. **Idempotent:** Can run multiple times safely
2. **Non-destructive:** Only creates commit if validation passes
3. **Atomic commits:** Single commit per task completion
4. **Rollback support:** Can revert commit if issues found
5. **Checkpoint resume:** Can abort and resume later (work preserved)

---

## Integration with Workflow

```
SELECT → next.md created
  ↓
PLAN → PRD created
  ↓
EXECUTE (pre-flight) → Shows plan
  ↓
[DEVELOPER WORKS] → Follows PRD
  ↓
EXECUTE (post-flight) → Validates
  ↓
Task complete → Run SELECT
```

---

## Command Variants

```bash
# Standard execution
claude "Выполни команду EXECUTE"
claude "Execute current task"

# Show plan only (no validation)
claude "EXECUTE: show plan"
claude "Show execution plan"

# Validate and commit only (skip pre-flight)
claude "EXECUTE: validate only"
claude "Validate and commit current task"

# With progress tracking
claude "EXECUTE with progress tracking"
```

---

## What EXECUTE Does NOT Do

- ❌ Does NOT write code automatically
- ❌ Does NOT "understand" requirements and implement
- ❌ Does NOT generate files from descriptions
- ❌ Does NOT debug or fix errors

**Developer (or Claude in separate requests) implements the task.**

EXECUTE only provides:
- ✅ Structured checklist
- ✅ Pre/post validation
- ✅ Automatic commit/push
- ✅ Progress tracking

---

## Exceptions

- **No next.md** → "No current task. Run SELECT first."
- **No PRD** → "No PRD for {TASK_ID}. Run PLAN first."
- **Task complete** → "Task already marked complete. Run SELECT for next."
- **Dependencies unsatisfied** → "Prerequisites not met: [list]. Complete them first."
- **Git not clean** → "Uncommitted changes. Commit or stash first."
- **Validation fails** → "Fix issues and retry with 'EXECUTE: validate only'"

---

## Notes

- EXECUTE is a **thin wrapper**, not an AI agent
- All implementation logic is in PRD, not in this command
- Developer follows PRD manually (or uses Claude in separate prompts)
- EXECUTE automates only the workflow boilerplate
- Can be run multiple times (idempotent)
- Always safe to abort (Ctrl+C)

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 2.0.0 | 2025-12-03 | Claude | Simplified to thin wrapper (removed auto-implementation) |
| 1.0.0 | 2025-12-03 | Claude | Initial version (too complex, deprecated) |
