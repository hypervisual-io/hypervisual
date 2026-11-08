---
name: hypervis-c4-container
description: Author, edit, validate, render, and troubleshoot HyperVisual `c4-container` diagrams. Use for C4 container diagrams showing deployable/runtime containers inside one software system. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual C4 Container

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need services, apps, databases, queues, or deployable units inside a scoped system.
- You need neighboring users/systems around those containers.

## Avoid This Diagram Type When

- You only need system context; use hypervis-c4-context.
- You need internals of one container; use hypervis-c4-component.

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
- `references/examples/01-system-containers.hvis`
- `references/examples/02-boundary-and-technology.hvis`
- `references/examples/03-payment-path-overlay.hvis` (path overlay via top-level `overlay:`; see `hypervis-cli` `references/overlays.md`)
