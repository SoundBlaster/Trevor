# Next Task: P1.2 — Implement One Euro filter

**Track:** macOS (P1)
**Priority:** High
**Effort:** High (Core filtering algorithm)
**Dependencies:** P1.1 (FilterCore API defined)
**Parallelizable:** No (Blocking for P1.3, P1.5, P1.6)
**Status:** Selected

## Description

Implement the One Euro filter algorithm in Swift to provide deterministic filtering for mouse tremor stabilization. This is the core filtering logic that will be used across the application.

## Context

- Part of the critical path (P1) for macOS implementation
- Required for W0.2 (Pointer Stabilization Playground) via TypeScript port
- Must handle variable delta-time and ensure no NaN/Inf output
- Performance must support 60Hz+ input rates

## Next Step

Run PLAN command to generate detailed PRD with test cases from TestPlan.md:
$ claude "Выполни команду PLAN"