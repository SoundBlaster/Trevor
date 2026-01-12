# Next Task: P1.3 — Implement preset mapping

**Track:** macOS (P1)
**Priority:** High
**Effort:** Medium (Preset configuration)
**Dependencies:** P1.2 (One Euro filter implementation)
**Parallelizable:** No (Blocking for P1.4, P1.5, P1.6)
**Status:** Selected

## Description

Implement preset mapping for the One Euro filter to provide predefined configurations for different use cases (e.g., fine control, general use, aggressive smoothing).

## Context

- Part of the critical path (P1) for macOS implementation
- Required for P1.4 (Slider → params mapping)
- Presets should be perceptually distinct and cover a range of use cases
- Must integrate with the One Euro filter implementation (P1.2)

## Next Step

Run PLAN command to generate detailed PRD with test cases from TestPlan.md:
$ claude "Выполни команду PLAN"