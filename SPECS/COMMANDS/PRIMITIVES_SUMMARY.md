# Primitives Improvement Summary

**Date:** 2026-01-12
**Project:** Trevor — Mouse Tremor Filter
**Purpose:** Atomic operations that support the main commands (SELECT, PLAN, EXECUTE, PROGRESS, ARCHIVE)

---

## Overview

All 5 primitives have been improved to be Trevor-specific:

1. **COMMIT.md** — Recording changes (both W0 and P0-P6)
2. **INSTALL_SWIFT.md** — Swift toolchain setup (P0-P6 only)
3. **GITLFS.md** — Build cache management (optional, P0-P6 only)
4. **ARCHIVE_TASK.md** — Per-task archival (both W0 and P0-P6)
5. **UPDATE_ARCHIVE_INDEX.md** — Archive index maintenance (both W0 and P0-P6)

---

## Primitive Details

### 1. COMMIT.md — Recording Changes

**Version:** 1.0 → 2.0
**Tracks:** W0 (Web Tools) + P0-P6 (macOS)

**Key Improvements:**
- ✅ Clear step-by-step workflow (status → stage → commit → verify)
- ✅ Commit message format: `{PHASE_ID}: {Verb} {Component}`
- ✅ Examples for each track:
  - W0: `W0.2: Implement canvas-based pointer playground`
  - P1: `P1.2: Implement One Euro filter algorithm`
  - P2: `P2.4: Inject synthetic events through CGEvent`
- ✅ Multi-line commit format with subtasks + test results
- ✅ Troubleshooting section (uncommitted changes, amend, reset)
- ✅ Always include test results in commit message

**Usage:**
- Called by EXECUTE after work is complete
- Called by ARCHIVE when moving tasks to history
- Used manually during development for checkpoint commits

**Example commit (P1.2 FilterCore):**
```bash
git add Sources/Core/Filter.swift Tests/FilterTests.swift
git commit -m "P1.2: Implement One Euro filter algorithm

- Define FilterCore API (interface + methods)
- Implement One Euro smoothing (cutoff + beta)
- Add dt normalization with clamping
- Handle NaN/Inf edge cases

Tests:
- XCTest: 23 unit tests passing ✓
- Latency: 0.45ms per sample (<0.5ms target) ✓
- Invariants: No NaN/Inf under variable dt ✓"
```

---

### 2. INSTALL_SWIFT.md — Swift Toolchain Setup

**Version:** 1.0 → 2.0
**Tracks:** P0-P6 (macOS) ONLY
**Not needed:** W0 (uses Node.js/npm)

**Key Improvements:**
- ✅ Project-specific header (Trevor, P0-P6)
- ✅ Verification section updated to test Trevor build
- ✅ Example test count expectations per phase:
  - P1: 23+ FilterCore unit tests
  - P2: 12+ event pipeline tests
  - P3-P6: UI, safety, export, QA tests
- ✅ Quick check if Swift is ready for EXECUTE

**Usage:**
- Called automatically by EXECUTE if Swift not found
- Can be run manually before starting P0-P6 work
- One-time setup per development environment

**Verification:**
```bash
cd /Users/egor/Development/GitHub/Trevor
swift --version    # Check installation
swift test         # Run all tests (count varies by phase)
```

---

### 3. GITLFS.md — Build Cache Management

**Version:** 1.0 → 2.0
**Tracks:** P0-P6 (macOS, optional)
**Not needed:** W0 (Web Tools)

**Key Improvements:**
- ✅ Project-specific header (Trevor, build cache optimization)
- ✅ Clear when needed vs optional
- ✅ Trevor-specific cache files: `swift-build-cache-darwin-arm64.tar.gz`
- ✅ Integration with EXECUTE: auto-restores cache during validation
- ✅ Reference to Trevor's cache scripts:
  - `./.github/scripts/create-build-cache.sh`
  - `./.github/scripts/restore-build-cache.sh`
  - `./.github/scripts/update-build-cache.sh`
- ✅ Performance benefit: 82s → 5-10s (8x faster)

**Usage:**
- Optional installation for faster Swift builds
- Called automatically by EXECUTE during post-flight validation
- Can be installed anytime for P0-P6 work

**When to use:**
- Working on P0-P6 (macOS) tasks
- Want 8x faster builds
- Have Git LFS server available

**When optional:**
- W0 (Web Tools) tasks
- Using local-only caching
- LFS server unavailable

---

### 4. ARCHIVE_TASK.md — Per-Task Archival

**Version:** 1.0 → 2.0
**Tracks:** W0 + P0-P6

**Key Improvements:**
- ✅ 4-step process clearly documented:
  1. Remove from next.md
  2. Move PRD file
  3. Add archive metadata (timestamp)
  4. Move summary file (optional)
- ✅ Phase ID format consistent: `P1.2`, `W0.2`, etc.
- ✅ Specific sed command for removal (careful range handling)
- ✅ Handles both PRD and summary files
- ✅ Full example: Archiving P1.2 FilterCore
- ✅ Verification section (check next.md, verify files moved, check metadata)
- ✅ Phase ID examples for all tracks

**Usage:**
- Called by ARCHIVE command for each completed task
- Can be called manually to archive individual tasks
- Runs before archive index update

**Example (P1.2 FilterCore):**
```bash
# Step 1: Remove from next.md
sed -i '/^# Next Task: P1\.2 .*/,/^# Next Task:.*\|$/d' SPECS/INPROGRESS/next.md

# Step 2: Move PRD
mv "SPECS/INPROGRESS/P1.2_FilterCore.md" "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"

# Step 3: Move summary
mv "SPECS/INPROGRESS/P1.2-FilterCore-summary.md" "SPECS/TASKS_ARCHIVE/P1.2-FilterCore-summary.md"

# Step 4: Add archive metadata
echo "" >> "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
echo "---" >> "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
echo "**Archived:** $(date '+%Y-%m-%d')" >> "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
```

---

### 5. UPDATE_ARCHIVE_INDEX.md — Archive Index Maintenance

**Version:** 1.0 → 2.0
**Tracks:** W0 + P0-P6

**Key Improvements:**
- ✅ Phase-based organization (8 sections):
  - W0 — Web Tools
  - P0 — Foundation
  - P1 — FilterCore
  - P2 — Event Pipeline
  - P3 — Application UI
  - P4 — Safety & Reliability
  - P5 — Trace Export
  - P6 — QA & Release
- ✅ Consistent entry format with links, effort, test results, notes
- ✅ Example entries for W0 and P1 showing full format
- ✅ Chronological ordering (newest first within each phase)
- ✅ Statistics block with:
  - Total Archived Tasks
  - Total Effort
  - Phases Represented
  - Critical Path completion status
- ✅ Last Updated timestamp

**Usage:**
- Called by ARCHIVE after archiving each task
- Maintains historical record of completed work
- Provides progress visibility by phase

**Entry Format:**
```markdown
- [✓ 2026-01-12] P1.2 — Implement One Euro Filter
  - Links: [PRD](./P1.2_FilterCore.md) | [Summary](./P1.2-FilterCore-summary.md)
  - Effort: High (core algorithm)
  - Tests: XCTest, 23 unit tests ✓, <0.5ms latency ✓
  - Notes: Shared with W0.2 (TS port), stable under variable dt ✓
```

**Statistics Example:**
```markdown
## Archive Statistics

- **Total Archived Tasks:** 8
- **Total Effort:** 42 hours
- **Phases Represented:** W0, P0, P1, P2 (4/8)
- **Last Updated:** 2026-01-12
- **Critical Path Complete:** P0 ✓, P1 ✓, P2 ✓, P3 ✗, P4 ✗, P6 ✗
```

---

## Usage Flow

### During EXECUTE Workflow
```
EXECUTE Phase 3 (Post-Flight Validation)
  ↓
  Tests run (npm test OR swift test)
  ↓
  [Tests pass]
  ↓
  COMMIT.md used → Stage & commit changes
  ↓
  Update Workplan + finalize
  ↓
  Task complete ✓
```

### During Batch Cleanup (ARCHIVE)
```
[Multiple tasks completed]
  ↓
  ARCHIVE command processes each task:
    1. ARCHIVE_TASK.md → Move PRD to history
    2. ARCHIVE_TASK.md → Move summary to history
    3. UPDATE_ARCHIVE_INDEX.md → Add to index
  ↓
  COMMIT.md → Commit archive changes
  ↓
  Workspace clean ✓
```

---

## Key Conventions

### Commit Messages
- Format: `{PHASE_ID}: {Verb} {Component}`
- Always include test results in multi-line commits
- Example: `P1.2: Implement One Euro filter`

### Archive Entries
- Format: `- [✓ YYYY-MM-DD] {PHASE_ID} — {Task Name}`
- Include links, effort, tests, notes
- Organized by phase (W0, P0, P1, ..., P6)

### File Naming
- PRDs: `{PHASE_ID}_{Task_Name}.md` (e.g., `P1.2_FilterCore.md`)
- Summaries: `{PHASE_ID}-{Task_Name}-summary.md` (e.g., `P1.2-FilterCore-summary.md`)
- Archives: Moved to `SPECS/TASKS_ARCHIVE/` directory

---

## Improvements Summary

| Primitive | Before | After | Impact |
|-----------|--------|-------|--------|
| COMMIT.md | Generic | Trevor-specific phases + test tracking | Clear commit history by phase |
| INSTALL_SWIFT.md | Hyperprompt refs | Trevor + P0-P6 only | Clarity on when Swift needed |
| GITLFS.md | Generic | Trevor build cache focus | Faster builds (optional) |
| ARCHIVE_TASK.md | Generic refs | SPECS/ paths + file handling | Proper archival workflow |
| UPDATE_ARCHIVE_INDEX.md | Generic phases | W0 + P0-P6 structure | Progress visibility |

---

## Quick Reference

### Commit
```bash
git add Sources/Core/Filter.swift
git commit -m "P1.2: Implement One Euro filter"
```

### Archive Single Task
```bash
# Run through ARCHIVE_TASK.md steps:
sed -i '/^# Next Task: P1\.2 .*/,/^# Next Task:.*\|$/d' SPECS/INPROGRESS/next.md
mv "SPECS/INPROGRESS/P1.2_FilterCore.md" "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
echo "" >> "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
echo "**Archived:** $(date '+%Y-%m-%d')" >> "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
```

### Install Swift (if needed)
```bash
# Run through INSTALL_SWIFT.md steps, then verify:
swift --version
swift test
```

### Check Archive Index
```bash
cat SPECS/TASKS_ARCHIVE/INDEX.md | grep "Phases Represented"
```

---

## When Each Primitive Is Used

| Primitive | Caller | Frequency | Required |
|-----------|--------|-----------|----------|
| COMMIT | EXECUTE + manual | Once per task | Yes |
| INSTALL_SWIFT | EXECUTE (auto-check) | Once per environment | For P0-P6 |
| GITLFS | EXECUTE (optional) | Once per environment | Optional |
| ARCHIVE_TASK | ARCHIVE | Per completed task | When archiving |
| UPDATE_ARCHIVE_INDEX | ARCHIVE | Per completed task | When archiving |

---

## Testing the Primitives

### Test COMMIT
```bash
# Stage files for a task
git add Sources/Core/Filter.swift Tests/FilterTests.swift

# Commit following format
git commit -m "P1.2: Test commit format"

# Verify commit message
git log -1
```

### Test ARCHIVE_TASK
```bash
# Create a test file in INPROGRESS
echo "test" > SPECS/INPROGRESS/TEST_Task.md

# Run archival steps
mv SPECS/INPROGRESS/TEST_Task.md SPECS/TASKS_ARCHIVE/TEST_Task.md
echo "**Archived:** $(date '+%Y-%m-%d')" >> SPECS/TASKS_ARCHIVE/TEST_Task.md

# Verify
ls SPECS/TASKS_ARCHIVE/TEST_Task.md
tail -1 SPECS/TASKS_ARCHIVE/TEST_Task.md
```

---

**End of Primitives Summary**
