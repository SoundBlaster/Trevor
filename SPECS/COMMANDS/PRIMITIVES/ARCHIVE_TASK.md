# ARCHIVE_TASK — Move Completed PRD (Trevor)

**Version:** 2.0
**Project:** Trevor Mouse Tremor Filter (W0 Web Tools + P0-P6 macOS phases)

## Purpose

Perform the per-task steps of the ARCHIVE command: remove the reference from `next.md`, move the PRD from `SPECS/INPROGRESS/` to `SPECS/TASKS_ARCHIVE/`, and add the archive timestamp so the history remains traceable.

## Usage

### Step 1: Remove from next.md

Remove the completed task entry from `SPECS/INPROGRESS/next.md`. Use a ranged edit or sed deletion:

```bash
# Manual: Edit next.md, remove section starting with:
# # Next Task: {PHASE_ID}.{TASK_NAME} —
# And ending before next section or EOF

# Or use sed (careful with ranges):
PHASE_ID="P1"
TASK_NAME="FilterCore"
sed -i '/^# Next Task: '"$PHASE_ID"'\..*/,/^# Next Task:.*\|$/d' SPECS/INPROGRESS/next.md
```

### Step 2: Move PRD File

Move the PRD from INPROGRESS to TASKS_ARCHIVE:

```bash
PHASE_ID="P1"
TASK_NAME="FilterCore"

mv "SPECS/INPROGRESS/${PHASE_ID}_${TASK_NAME}.md" \
   "SPECS/TASKS_ARCHIVE/${PHASE_ID}_${TASK_NAME}.md"
```

### Step 3: Add Archive Metadata

Append completion timestamp to archived PRD:

```bash
PHASE_ID="P1"
TASK_NAME="FilterCore"

echo "" >> "SPECS/TASKS_ARCHIVE/${PHASE_ID}_${TASK_NAME}.md"
echo "---" >> "SPECS/TASKS_ARCHIVE/${PHASE_ID}_${TASK_NAME}.md"
echo "" >> "SPECS/TASKS_ARCHIVE/${PHASE_ID}_${TASK_NAME}.md"
echo "**Archived:** $(date '+%Y-%m-%d %H:%M')" >> "SPECS/TASKS_ARCHIVE/${PHASE_ID}_${TASK_NAME}.md"
```

### Step 4: Move Summary (if exists)

If a task summary was created, move it too:

```bash
if [ -f "SPECS/INPROGRESS/${PHASE_ID}-${TASK_NAME}-summary.md" ]; then
  mv "SPECS/INPROGRESS/${PHASE_ID}-${TASK_NAME}-summary.md" \
     "SPECS/TASKS_ARCHIVE/${PHASE_ID}-${TASK_NAME}-summary.md"
fi
```

## Example

Archiving completed task P1.2 (FilterCore):

```bash
PHASE_ID="P1.2"
TASK_NAME="FilterCore"

# 1. Remove from next.md
sed -i '/^# Next Task: P1\.2 .*/,/^# Next Task:.*\|$/d' SPECS/INPROGRESS/next.md

# 2. Move PRD
mv "SPECS/INPROGRESS/P1.2_FilterCore.md" "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"

# 3. Move summary
mv "SPECS/INPROGRESS/P1.2-FilterCore-summary.md" "SPECS/TASKS_ARCHIVE/P1.2-FilterCore-summary.md"

# 4. Add archive metadata
echo "" >> "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
echo "---" >> "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
echo "" >> "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
echo "**Archived:** $(date '+%Y-%m-%d')" >> "SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md"
```

## Guidelines

- **Perform all steps** before updating the archive index so files exist in correct location
- **Double-check next.md** after edit — ensure only intended block was removed
- **Keep ID/Name casing** consistent between source and target paths
- **Format:** Use `{PHASE_ID}_{TASK_NAME}` (e.g., `W0.2_Playground`, `P1.2_FilterCore`)
- **Summary file:** Include `-summary` suffix (e.g., `P1.2-FilterCore-summary.md`)
- **Phase ID examples:** `W0.1`, `P0.2`, `P1.2`, `P3.5`, `P6.1`

## Verification

After archiving, verify:

```bash
# Check next.md no longer mentions the task
grep "P1.2" SPECS/INPROGRESS/next.md  # Should show nothing

# Check files moved to archive
ls -la SPECS/TASKS_ARCHIVE/P1.2_*

# Check metadata appended
tail -5 SPECS/TASKS_ARCHIVE/P1.2_FilterCore.md
# Should show:
# ---
# **Archived:** 2026-01-12
```
