# HyperVisual Gantt Grammar

## Declaration

```yaml
BasicPlan[gantt]:
  - timeline:
      scale: day
      today: 2026-06-10
  - Design[task]:
      start: 2026-06-01
      end: 2026-06-04
  - Build[task]:
      start: 2026-06-05
      duration: 6d
      depends_on:
        - Design
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations.

## Type-Specific Notes

- Use `timeline:` (often as a list item) for scale and `today` when you need a reference date.
- Use `calendar:` for timezone, work week, and holidays.
- Use tasks for date ranges, milestones for single dates, and groups/lanes for organization.
- **Gantt does not use arrow edges.** Declare predecessor/successor links with `depends_on:` on the task or milestone. Optional entries can set `type` (for example `finish-start`), `lag`, `lead`, `critical`, or reference another task by name.

## Nesting

Under a `group` or `lane`, list nested tasks and milestones as YAML list items in the group body. Do not wrap them in `children:` (removed in v0.1.0).

## Labels and Properties

A scalar string after a node colon becomes a node description. Mapping values become structured properties and should be preferred for detailed diagrams.
