# HyperVisual C4 Component Authoring Guide

## Purpose

C4 component diagrams showing components inside one container and nearby containers/systems.

## Choose This Type When

- You need controllers, services, adapters, modules, or other components inside one container.
- You need to show how components interact with neighboring containers and systems.

## Prefer Another Type When

- You need container-level deployment/runtime structure; use hypervis-c4-container.
- You need class/code internals; use hypervis-c4-code or hypervis-class.

## Minimal Shape

```yaml
Example[c4-component]:
  - FirstNode[component]
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
