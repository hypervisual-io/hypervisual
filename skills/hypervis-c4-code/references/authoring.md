# HyperVisual C4 Code Authoring Guide

## Purpose

C4 code-level diagrams showing classes, interfaces, functions, modules, and packages inside one component.

## Choose This Type When

- You need code-level architecture inside one component.
- You want C4 context plus class-like structure and structural relationship validation.

## Prefer Another Type When

- You only need pure UML/domain classes; use hypervis-class.
- You need component-level architecture; use hypervis-c4-component.

## Minimal Shape

```yaml
Example[c4-code]:
  - FirstNode[class]
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
