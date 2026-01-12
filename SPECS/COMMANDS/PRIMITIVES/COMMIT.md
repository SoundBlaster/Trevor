# COMMIT — Record Changes (Trevor)

**Version:** 2.0
**Project:** Trevor Mouse Tremor Filter (W0 Web Tools + P0-P6 macOS)

## Purpose

Capture clean, descriptive snapshots of work for each task. Keep commits focused and tied to COMBINED_Workplan phases.

## Usage

### Step 1: Check Git Status
```bash
git status -sb             # See staged vs unstaged files
```

### Step 2: Stage Files for Current Task
```bash
# Stage only files touched in the current task/phase
git add Sources/Core/Filter.swift      # macOS example
git add src/playground.tsx             # web example

# Review staged changes
git diff --cached
```

### Step 3: Commit with Descriptive Message
```bash
# Format: {PHASE_ID}: {Action} {Component}
#
# Examples:
git commit -m "P1.2: Implement One Euro filter algorithm"
git commit -m "W0.2: Add canvas playground with preset selector"
git commit -m "P2.3: Implement event suppression logic"
```

### Step 4: Verify Clean Working Tree
```bash
git status -sb             # Must show nothing (or untracked files only)
```

## Commit Message Format

### Simple (Single-line)
```
{PHASE_ID}: {Verb} {Component}

Examples:
P1.2: Implement One Euro filter
P2.4: Inject synthetic mouse events
P3.5: Add stability slider UI
W0.2: Port FilterCore to TypeScript
P4.1: Add bypass hotkey handler
P6.1: Run golden test suite
```

### Detailed (Multi-line, optional)
```
{PHASE_ID}: {Verb} {Component}

Description of changes (if needed):
- Subtask 1 completed
- Subtask 2 completed
- Performance: Latency <0.5ms ✓

Tests:
- swift test: 23 passed ✓
- Performance: OK ✓
```

## Guidelines

- **Keep commits focused:** Include only files touched in current task (from PRD)
- **Use present tense:** `Implement`, `Add`, `Fix`, not `Implemented`, `Added`, `Fixed`
- **Reference phase ID:** Always start with `{PHASE_ID}:` (e.g., `P1.2:`, `W0.2:`)
- **One task per commit:** If batching multiple tasks, commit each separately
- **Batch archives separately:** When archiving, use: `ARCHIVE: Move P1.2 to history`
- **No uncommitted code:** Always verify `git status` clean before EXECUTE finalization

## Examples by Phase

### Web Tools (W0)
```bash
git add src/filter.ts src/playground.tsx tests/*.test.ts
git commit -m "W0.2: Implement canvas-based pointer playground

- Render raw vs filtered paths side-by-side
- Add preset selector dropdown
- Add stability slider (0-100)
- Implement space-key precision hold toggle

Tests:
- Jest suite: 8 tests passing ✓
- Frame time: 12ms average (<16ms target) ✓"
```

### macOS FilterCore (P1)
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

### macOS Event Pipeline (P2)
```bash
git add Sources/Event/EventTap.swift Sources/Event/Injection.swift
git commit -m "P2.4: Inject synthetic events through CGEvent

- Suppress original tremor events
- Inject filtered pointer coordinates
- Maintain <2ms latency E2E
- Handle event ordering correctly

Tests:
- XCTest: 12 event pipeline tests passing ✓
- E2E latency: 1.8ms (<2ms target) ✓"
```

## Integration

This primitive is called by:
- **EXECUTE:** After work is done, before finalization
- **ARCHIVE:** After moving PRDs to archive

When you need a quick reminder, open this file for the minimal checklist.

## Common Issues

**"Uncommitted changes block EXECUTE"**
```bash
# See what's uncommitted
git status -sb

# Stage only current task files
git add src/filter.ts

# Commit
git commit -m "P1.2: Implement filter"

# Verify clean
git status -sb
```

**"Forgot to add a file"**
```bash
# Add the missing file
git add Sources/Event/Permission.swift

# Amend the last commit (only if not pushed)
git commit --amend --no-edit

# If already pushed, make a new commit
git commit -m "P2.5: Add permission detection logic"
```

**"Committed wrong files"**
```bash
# Revert last commit (keep files)
git reset --soft HEAD~1

# Stage correct files
git add Sources/Core/Filter.swift

# Re-commit
git commit -m "P1.2: Implement One Euro filter"
```
