# HyperVisual Gantt Authoring Guide

## Purpose

Project plans, timelines, milestones, resources, dependencies, lanes, groups, deadlines, and critical path views.

## Choose This Type When

- You need schedule, dates, durations, resources, milestones, dependencies, and progress.
- You need a timeline/table render rather than a node-link graph.

## Prefer Another Type When

- You need a generic process without calendar semantics; use flowchart or activity.

## Minimal Shape

```yaml
Example[gantt]:
  - timeline:
      scale: day
      today: 2026-09-01
  - Solo[task]:
      start: 2026-09-01
      end: 2026-09-02
```

## Production Pattern

- Declare important nodes before edges.
- Use stable names because HyperVisual identity is name-based.
- Add labels on relationships where the validator or reader benefits from intent.
- Prefer structured properties over overloaded labels when a property exists.
- Keep examples valid by running `hypervis validate`.
- Use `hypervis help render` before assuming installed render flags.

## Common Mistakes

- Referencing an undeclared edge endpoint.
- Mixing a diagram type's vocabulary with a lower-level or unrelated diagram type.
- Using a render target as source syntax. Render size belongs on the CLI, not in `.hvis`.
- Relying on stale command flags instead of `hypervis help <command>`.
