# HyperVisual Activity Authoring Guide

## Purpose

UML-style activity diagrams with actions, object flows, control nodes, swimlanes, forks, joins, and regions.

## Choose This Type When

- You need UML activity semantics rather than a generic flowchart.
- You need swimlanes/partitions, object nodes, pins, forks, joins, or guarded decisions.
- You need validation for object-flow versus control-flow mistakes.

## Prefer Another Type When

- You only need a simple process sketch; use flowchart.
- You need state over time; use state-machine.

## Minimal Shape

```yaml
Example[activity]:
  - FirstNode[action]
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
