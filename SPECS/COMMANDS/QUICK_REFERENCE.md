# Quick Reference — Trevor Commands & Workflow

**Project:** Mouse Tremor Filter (Web Tools W0 + macOS P0-P6)
**Single Source of Truth:** `SPECS/PRD/Workplan.md` + `SPECS/PRD/TestPlan.md`

---

## The Five Commands

### 1. SELECT — Pick Next Task
```bash
$ claude "Выполни команду SELECT"
```
**Reads:** Workplan.md (W0 + P0-P6 phases)
**Writes:** next.md (minimal metadata)
**Output:** Task ready for PLAN

**When to use:**
- Starting work session
- Completed previous task, need next one
- Want to check which task has highest priority

**What it does:**
- Respects W0 fully parallel, P0-P6 blocking chain
- Suggests P1→P2→P3→P4→P6 critical path first
- Can suggest parallel W0 work if available

---

### 2. PLAN — Generate PRD
```bash
$ claude "Выполни команду PLAN"
```
**Reads:** next.md + Workplan.md + TestPlan.md
**Writes:** {PHASE_ID}_{TASK_NAME}.md (detailed PRD + test cases)
**Output:** PRD ready for EXECUTE

**When to use:**
- After SELECT chooses a task
- Need detailed implementation instructions
- Need test cases for the phase

**What it does:**
- Extracts task breakdown from COMBINED_Workplan
- Includes test cases + acceptance criteria from TestPlan
- Generates step-by-step implementation guide

---

### 3. EXECUTE — Do the Work
```bash
$ claude "Выполни команду EXECUTE"
```
**Reads:** next.md + PRD + TestPlan.md
**Runs:** Appropriate tests (npm test OR swift test)
**Writes:** Updated workplan + commit

**When to use:**
- After PLAN generates PRD
- Ready to implement task
- Ready to run tests and commit

**What it does:**
1. **Pre-flight:** Checks git, installs toolchain (Node or Swift), shows plan
2. **Work:** You follow PRD, implement task
3. **Validate:** Runs tests (web: Jest, macOS: XCTest)
4. **Finalize:** Updates workplan, commits, pushes

**Track-specific tests:**
- **W0 (Web):** `npm test` + `npm run build`
- **P0-P6 (macOS):** `swift test` + Swift build

---

### 4. PROGRESS — Update Subtasks (Optional)
```bash
$ claude "Выполни команду PROGRESS"
```
**Reads:** next.md (current task checklist)
**Writes:** Updated next.md with marked subtasks
**Optional:** Auto-called by EXECUTE

**When to use:**
- Long tasks (>2 hours), want visibility
- Completing subtasks during work session
- Tracking progress without full EXECUTE

---

### 5. ARCHIVE — Clean Up Completed Tasks
```bash
$ claude "Выполни команду ARCHIVE"
```
**Reads:** Workplan.md (completed tasks `[x]`)
**Moves:** PRDs from INPROGRESS → TASKS_ARCHIVE
**Updates:** INDEX.md by phase

**When to use:**
- After completing 2-3 tasks
- Before starting new phase
- Workspace cleanup

---

## File Structure

```
SPECS/
├── PRD/
│   ├── Workplan.md      ← READ by SELECT
│   └── TestPlan.md               ← READ by PLAN + EXECUTE
│
├── INPROGRESS/
│   ├── next.md                   ← Current task
│   └── W0.2_Playground.md        ← Current PRD
│
└── COMMANDS/
    ├── SELECT.md, PLAN.md, EXECUTE.md, PROGRESS.md, ARCHIVE.md
    └── PRIMITIVES/
        ├── COMMIT.md
        ├── INSTALL_SWIFT.md      ← If Swift needed
        └── GITLFS.md             ← Optional for caching
```

---

## Task Phases (from Workplan.md)

### W0 — Web Tools (Fully Parallel)
- **W0.1:** Landing Page
- **W0.2:** Playground (depends on P1.2 FilterCore)
- **W0.3:** Test Suite
- **W0.4:** Feedback Form
- **W0.5:** Trace Tuner (internal)

### P0 — Foundation (Blocking)
- **P0.1:** Freeze scope
- **P0.2:** Finalize specs
- **P0.3:** Repo structure
- **P0.4:** CI pipeline

### P1 — FilterCore (Critical Path)
- **P1.1:** Define API
- **P1.2:** Implement filter ← *Shared with W0.2*
- **P1.3:** Presets
- **P1.4:** Slider mapping
- **P1.5:** dt normalization
- **P1.6:** Unit tests
- **P1.7:** Benchmarks

### P2 — Event Pipeline (Critical Path)
- **P2.1:** Select mechanism
- **P2.2:** Event capture
- **P2.3:** Suppress events
- **P2.4:** Inject synthetic events
- **P2.5:** Permissions
- **P2.6:** Event rate measurement
- **P2.7:** Fallback

### P3 — App UI
- **P3.1:** Settings
- **P3.2:** Menubar
- **P3.3:** On/Off controls
- **P3.4:** Preset selector
- **P3.5:** Stability slider
- **P3.6:** Precision Hold
- **P3.7:** Test canvas
- **P3.8:** Onboarding

### P4 — Safety & Reliability
- **P4.1:** Bypass hotkey
- **P4.2:** Crash detection
- **P4.3:** Safe-start logic
- **P4.4:** Recovery UX
- **P4.5:** Logging policy

### P5 — Trace Export (Optional, Parallel)
- **P5.1:** Recording state machine
- **P5.2:** Guided exercises
- **P5.3:** Schema
- **P5.4:** Quality validation
- **P5.5:** ZIP exporter
- **P5.6:** Privacy UI

### P6 — QA & Release
- **P6.1:** Golden tests
- **P6.2:** Regression replay
- **P6.3:** Performance profiling
- **P6.4:** Sign & notarize
- **P6.5:** Docs
- **P6.6:** Beta feedback

---

## Acceptance Criteria (from TestPlan.md)

### FilterCore (P1)
- [ ] No NaN/Inf output
- [ ] Latency <0.5ms per sample
- [ ] Stable under variable dt
- [ ] Presets perceptually distinct

### Event Pipeline (P2)
- [ ] Raw events captured at expected rate
- [ ] Events suppressed when enabled
- [ ] Filtered events injected correctly
- [ ] Permissions detected properly

### UI (P3)
- [ ] Settings persist
- [ ] Controls responsive (<100ms latency)
- [ ] Onboarding guides user through permissions
- [ ] No restart required for setting changes

### Safety (P4)
- [ ] Bypass hotkey works within 10ms
- [ ] Crashes auto-disable filter on restart
- [ ] No permission cascade failures
- [ ] User always regains control

### Web Tools (W0)
- [ ] Playground renders at 60 FPS (frame time <16ms)
- [ ] Presets switchable in real-time
- [ ] Slider responsive to input
- [ ] Jest tests pass
- [ ] Trace ZIP format valid

---

## Common Workflows

### Start Development Session
```bash
SELECT → PLAN → EXECUTE
```

### Finish a Task, Start Next
```bash
[EXECUTE completes]
↓
SELECT → PLAN → EXECUTE
```

### Multiple Tasks Done, Clean Up
```bash
[3 tasks completed]
↓
ARCHIVE → SELECT → PLAN → EXECUTE
```

### Check Current Task Status
```bash
$ cat SPECS/INPROGRESS/next.md
$ cat SPECS/INPROGRESS/P1.2_*.md | head -30
```

### View Workplan Progress
```bash
$ grep "^\- \[" SPECS/PRD/Workplan.md | head -20
```

---

## Parallel Work Example

**Scenario:** P1.2 (FilterCore) just completed

**Recommended Actions:**
1. **Web developer:** `SELECT` → chooses W0.2 (can now run, depends on P1.2)
2. **macOS developer:** `SELECT` → chooses P2.1 (next critical path task)
3. Both run PLAN + EXECUTE in parallel
4. P1.2 output (FilterCore Swift) needed by W0.2, so web dev waits for actual algorithm

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "No current task" | Run `SELECT` first |
| "PRD not found" | Run `PLAN` after SELECT |
| "Swift not found" | EXECUTE will offer to run INSTALL_SWIFT |
| "npm not found" | Install Node.js + npm, or use macOS task instead |
| "Tests fail" | Fix code, don't commit until tests pass |
| "Dependencies blocked" | Complete prerequisite tasks first (check COMBINED_Workplan) |
| "Git not clean" | Commit or stash changes before EXECUTE |

---

## Test Commands by Track

### Web Tools (W0)
```bash
npm test                 # Run Jest
npm run build           # Build TypeScript
npm run perf            # Performance tests (if defined)
```

### macOS (P0-P6)
```bash
swift test              # Run XCTest
swift build             # Compile
swift run benchmark-*   # Run benchmarks (if defined)
```

### Before Any Commit
```bash
git status              # Must be clean
[run track-specific tests above]
# Must pass before EXECUTE will commit
```

---

## Key Files to Know

| File | Purpose | Read by | Updated by |
|------|---------|---------|-----------|
| Workplan.md | Master task list (W0 + P0-P6) | SELECT, PLAN, EXECUTE | EXECUTE |
| TestPlan.md | Acceptance criteria per phase | PLAN, EXECUTE | Manual updates |
| next.md | Current task metadata | PLAN, EXECUTE | SELECT, EXECUTE |
| {PHASE_ID}_{NAME}.md | Detailed PRD + test cases | EXECUTE | PLAN |
| Package.swift | Swift project (macOS only) | Swift build | Manual updates |
| package.json | Node.js project (web only) | npm build | Manual updates |

---

## Remember

- **SELECT** once per task
- **PLAN** after SELECT
- **EXECUTE** does the real work + testing + commit
- **PROGRESS** is optional, for long tasks
- **ARCHIVE** periodically to keep workspace clean
- **COMBINED_Workplan + TestPlan** are your specs — follow them
- **Tests must pass** before any commit
- **W0 and P0-P6** can run in parallel

---

**Quick Start:**
```bash
$ claude "Выполни команду SELECT"
$ claude "Выполни команду PLAN"
$ claude "Выполни команду EXECUTE"
```

That's it! Follow the PRD + TestPlan, implement, tests run automatically, commit happens automatically.

---
