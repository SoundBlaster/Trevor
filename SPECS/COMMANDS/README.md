# Trevor: Mouse Tremor Filter — Workflow Commands

**Version:** 3.0.0
**Project:** Mouse Tremor Filtering (Web Tools W0 + macOS Phases P0-P6)
**Last Updated:** 2026-01-12
**Adaptation Status:** ✅ Complete
**Documentation Sources:**
- [COMBINED_Workplan.md](../PRD/COMBINED_Workplan.md) — Master task list (W0 + P0-P6)
- [TestPlan.md](../PRD/TestPlan.md) — QA testing strategy (aligned to phases)

## Overview

Five commands implement a documentation-driven development workflow for the Trevor project, spanning W0 (Web Tools) and P0-P6 (macOS phases).

| Command | Purpose | Details |
|---------|---------|---------|
| **SELECT** | Choose next task from COMBINED_Workplan | [SELECT.md](./SELECT.md) |
| **PLAN** | Generate implementation-ready PRD | [PLAN.md](./PLAN.md) |
| **EXECUTE** | Workflow wrapper (pre/post checks, build, test) | [EXECUTE.md](./EXECUTE.md) |
| **PROGRESS** | Update task checklist (optional) | [PROGRESS.md](./PROGRESS.md) |
| **ARCHIVE** | Move completed PRDs to archive | [ARCHIVE.md](./ARCHIVE.md) |

---

## Workflow

```
┌─────────┐
│ SELECT  │  Choose highest priority task (W0 or P0-P6)
└────┬────┘  Updates: next.md, Workplan.md
     ↓
┌─────────┐
│  PLAN   │  Generate detailed PRD (web or macOS context)
└────┬────┘  Creates: DOCS/INPROGRESS/{TASK_ID}_{TASK_NAME}.md
     ↓
┌─────────┐
│ EXECUTE │  Pre-flight → [YOU WORK] → Post-flight
└────┬────┘  Runs web tests + Swift tests, commits, pushes
     ↓
  [REPEAT] ←──────────┐
     │                │
     │  (periodically)│
     ↓                │
┌─────────┐           │
│ ARCHIVE │  Clean workspace, move completed PRDs
└─────────┘  To: SPECS/TASKS_ARCHIVE/
```

**Philosophy:** All implementation instructions exist in Workplan.md and TestPlan.md. Commands automate only workflow boilerplate.

---

## Quick Start

```bash
# 1. Choose task (W0, P0-P6 phases)
$ claude "Выполни команду SELECT"

# 2. Generate PRD (web tools or macOS)
$ claude "Выполни команду PLAN"

# 3. Execute (pre-flight → [YOU WORK] → validate → commit)
# Runs: web tests (Jest), macOS tests (XCTest), build checks
$ claude "Выполни команду EXECUTE"

# 4. Repeat for next task
$ claude "Выполни команду SELECT"
```

---

## Three-Level Task Hierarchy

| Level | File | Granularity | Purpose |
|-------|------|-------------|---------|
| **Strategic** | Workplan.md | W0 + P0-P6 phases | Web tools + macOS phases, dependencies, parallelization |
| **Tactical** | next.md | 5-15 items per task | Daily checklist for current task |
| **Operational** | PRD | Atomic steps | Implementation steps, test cases, acceptance criteria |

**Example (W0 Track):**
- Workplan.md: `W0.2 Pointer Stabilization Playground — depends on P1.2 (FilterCore)`
- next.md: `- [ ] Port FilterCore to TypeScript` (5 items)
- PRD: `Task 2.1: Implement One Euro filter in TypeScript with test cases`

**Example (macOS Track):**
- Workplan.md: `P1.2: Implement One Euro filter [High] — depends on P1.1`
- next.md: `- [ ] Create filter.swift with interface` (8 items)
- PRD: `Task 1.2.1: Define FilterCore API, Task 1.2.2: Implement algorithm with unit tests`

---

## Command Details

### SELECT
Chooses next task based on:
- Dependencies satisfied
- Highest priority (P0 > P1 > P2)
- Critical path preference

**Output:** Updates `next.md` and `Workplan.md`

👉 **[Full details in SELECT.md](./SELECT.md)**

---

### PLAN
Generates implementation-ready PRD from:
- Task in `next.md` (selected from Workplan.md)
- Context from `Workplan.md` (phase, dependencies, priority)
- Test cases from `TestPlan.md` (section corresponding to phase)
- Rules from `01_PRD_PROMPT.md`
- Project specs (FilterCore, Event Pipeline, UI, Safety, Web Tools)

**Output:** `SPECS/INPROGRESS/{TASK_ID}_{TASK_NAME}.md`

👉 **[Full details in PLAN.md](./PLAN.md)**

---

### EXECUTE ⭐

**Thin workflow wrapper** (NOT an AI agent):

1. **Pre-flight:** Check git, dependencies, ensure Swift is installed
2. **Work period:** `[DEVELOPER FOLLOWS PRD]`
3. **Post-flight:** Run tests (web + macOS), validate against TestPlan.md, commit, push
4. **Finalize:** Update docs, suggest next task

**Important:** PRD + TestPlan.md contain all implementation instructions and acceptance criteria. EXECUTE only automates checks and commits.

**Tests run (depending on task type):**
- **Web Tools (W0):** `npm test` (Jest), performance benchmarks
- **macOS (P1-P6):** `swift test` (XCTest), FilterCore benchmarks (P1.7), performance profiling (P6.3)
- **Both:** Build validation, git checks, cache management

**Modes:**
- Full (default) — complete workflow (pre-flight → work → post-flight → finalize)
- Show plan — preview only
- Validate only — post-implementation (skip pre-flight)
- Progress tracking — periodic checkpoints during long tasks

👉 **[Full details in EXECUTE.md](./EXECUTE.md)**

---

### PROGRESS
Optional command to update task checklist during work.

**Auto-called by EXECUTE**, so usually not needed separately.

👉 **[Full details in PROGRESS.md](./PROGRESS.md)**

---

### ARCHIVE
Moves completed task PRDs from `INPROGRESS/` to `TASKS_ARCHIVE/`.

**When to use:**
- After completing multiple tasks (batch cleanup)
- Before starting new phase
- When INPROGRESS/ becomes cluttered

**What it does:**
- Scans for completed tasks (marked `[x]` in Workplan)
- Moves PRDs to `DOCS/TASKS_ARCHIVE/`
- Generates `INDEX.md` organized by phase
- Commits and pushes

**Not required** — run periodically to keep workspace clean.

👉 **[Full details in ARCHIVE.md](./ARCHIVE.md)**

---

## File Structure

```
SPECS/
├── COMMANDS/              # This directory
│   ├── README.md          # This file (overview)
│   ├── SELECT.md          # Full SELECT spec
│   ├── PLAN.md            # Full PLAN spec
│   ├── EXECUTE.md         # Full EXECUTE spec
│   ├── PROGRESS.md        # Full PROGRESS spec
│   ├── FLOW.md            # Workflow cycle
│   ├── REVIEW.md          # Code review command
│   ├── ARCHIVE.md         # Full ARCHIVE spec
│   └── PRIMITIVES/        # Atomic operations
│       ├── COMMIT.md      # Recording changes
│       ├── INSTALL_SWIFT.md
│       ├── GITLFS.md
│       ├── ARCHIVE_TASK.md
│       └── UPDATE_ARCHIVE_INDEX.md
│
├── INPROGRESS/            # Active work
│   ├── next.md            # Current task
│   └── {TASK_ID}_{NAME}.md  # Active task PRDs
│
├── TASKS_ARCHIVE/         # Completed tasks
│   ├── INDEX.md           # Organized by phase (W0, P0-P6)
│   └── {TASK_ID}_{NAME}.md  # Archived PRDs
│
├── PRD/                   # Project specifications
│   ├── Workplan.md    # Master: W0 + P0-P6 phases
│   ├── TestPlan.md             # QA testing strategy
│   └── [other design specs]
│
└── RULES/
    └── 01_PRD_PROMPT.md   # PRD generation rules
```

---

## Common Workflows

### Starting New Task
```bash
SELECT → PLAN → EXECUTE
```
*Picks next task from Workplan.md (W0 or P0-P6), generates PRD, runs implementation + tests*

### Choosing Between Web (W0) and macOS (P0-P6) Work
```bash
# SELECT will choose based on priority and parallelization rules
# W0 tasks fully parallel to P0-P6 (can work on both simultaneously)
$ claude "Выполни команду SELECT"

# View current selection
$ cat SPECS/INPROGRESS/next.md | head -5
# → Shows which phase: W0.2, P1.3, P4.1, etc.
```

### Resuming After Break
```bash
# Check current task and phase
$ cat SPECS/INPROGRESS/next.md

# Continue with EXECUTE (includes appropriate tests for web or macOS)
$ claude "Выполни команду EXECUTE"
```

### Checking Progress
```bash
# View checklist for current task
$ cat SPECS/INPROGRESS/next.md

# View PRD details
$ cat SPECS/INPROGRESS/W0.2_Playground.md
$ cat SPECS/INPROGRESS/P1.2_FilterCore.md

# Overall status (see which phase completed)
$ grep "^\- \[" SPECS/PRD/Workplan.md | grep -E "^(W0|P[0-6])"
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "No PRD found" | Run `PLAN` command first |
| "Dependencies not satisfied" | Complete prerequisite tasks first |
| "Git not clean" | Commit or stash changes |
| "Task already complete" | Run `SELECT` for next task |

For detailed error handling, see individual command files.

---

## Key Principles (Trevor-Specific)

1. **Single Source of Truth**
   - Phase strategy → Workplan.md (W0 + P0-P6)
   - Test requirements → TestPlan.md (aligned to phases)
   - Implementation details → PRD
   - Current task → next.md
   - Commands → automation only

2. **Dual-Track Development**
   - W0 (Web Tools) fully parallel to P0-P6 (macOS)
   - SELECT will suggest best parallelization
   - EXECUTE runs appropriate tests (web or macOS or both)

3. **Documentation-Driven**
   - Workplan.md = strategy + phases + dependencies
   - TestPlan.md = acceptance criteria for each phase
   - PRD = atomic, executable steps
   - Implement following PRD, validate against TestPlan

4. **Thin Wrappers**
   - Commands don't implement logic
   - Commands structure the process
   - Developer follows documentation (PRD + TestPlan)

5. **Testing is First-Class**
   - Web tests (Jest) run for W0 tasks
   - Unit/integration tests (XCTest) run for P0-P6 tasks
   - Performance tests run before release (P1.7, P6.3)
   - EXECUTE won't commit until tests pass

