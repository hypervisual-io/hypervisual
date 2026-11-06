---
name: hypervis-c4-component
description: Author, edit, validate, render, and troubleshoot HyperVisual `c4-component` diagrams. Use for C4 component diagrams showing components inside one container and nearby containers/systems. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual C4 Component

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need controllers, services, adapters, modules, or other components inside one container.
- You need to show how components interact with neighboring containers and systems.

## Avoid This Diagram Type When

- You need container-level deployment/runtime structure; use hypervis-c4-container.
- You need class/code internals; use hypervis-c4-code or hypervis-class.

## Authoring Workflow

1. Read `references/authoring.md` for diagram selection and common patterns.
2. Read `references/vocabulary.md` and `references/properties.md` before writing detailed nodes or edges.
3. Use examples from `references/examples/` as source templates.
4. Validate with `hypervis validate <file>`.
5. Render with `hypervis render <file> --format svg -o <file.svg>` when the CLI is available.

## References

- Structure and grammar: `references/grammar.md`
- Node and edge vocabulary: `references/vocabulary.md`
- Valid properties: `references/properties.md`
- Validation rules and common repairs: `references/validation.md`
- Layout and rendering behavior: `references/layout-rendering.md`
- Examples:
- `references/examples/01-service-components.hvis`
- `references/examples/02-container-boundary.hvis`
