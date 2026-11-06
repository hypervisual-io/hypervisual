# HyperVisual Gantt Validation

## Main Rules

- Tasks need start and end/finish/duration.
- Milestones need date and must have identical start/end semantics.
- Dependencies are modeled with `depends_on:`; they must reference known tasks and cannot form cycles.
- Arrow edges (`A --> B`) are invalid for Gantt; the parser rejects them.
- Dates and durations are validated.
- Resources referenced by tasks should exist when modeled explicitly.

## Repair Loop

1. Run `hypervis validate <file>`.
2. Read each diagnostic code, node, edge, and path.
3. Fix the source rather than suppressing diagnostics.
4. Rerun validation.
5. Render only after error and critical diagnostics are gone.

## Strict Mode

Use `hypervis validate <file> --strict` when producing best-practice examples or documentation diagrams. Strict mode may promote supported convention warnings.

## Common Repairs

- Replace arrow dependencies with `depends_on:` on the successor task or milestone.
- Add missing task declarations referenced by `depends_on`.
- Rename duplicate nodes or intentionally nest them where the type supports scope.
- Replace invalid node types with vocabulary entries from `vocabulary.md`.
- Replace unsupported properties with entries from `properties.md`.
