# HyperVisual Flowchart Authoring Guide

## Purpose

Generic directed process flows with decisions, stages, nested groups, and readable domain-specific node kinds.

## Choose This Type When

- You need a directed process or decision flow.
- The node vocabulary should remain flexible but the graph should be structured.
- You need nested process groups with directed layout.

## Prefer Another Type When

- You need UML activity semantics such as object flows, pins, partitions, forks, and joins.
- You need a timeline; use Gantt.

## Minimal Shape

```yaml
Example[flowchart]:
  - layout:
      direction: TB
  - Solo[process]: "one step"
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
