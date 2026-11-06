---
name: hypervis-c4-context
description: Author, edit, validate, render, and troubleshoot HyperVisual `c4-context` diagrams. Use for C4 system context diagrams showing one software system in scope, its users, and external systems. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual C4 Context

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need a high-level system context for humans and neighboring systems.
- You want to communicate boundaries and external dependencies before container/component detail.
- You need C4 validation for context-level vocabulary.

## Avoid This Diagram Type When

- You need deployable/runtime internals; use hypervis-c4-container.
- You need code/class internals; use hypervis-c4-code or hypervis-class.

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
- `references/examples/01-saas-context.hvis`
- `references/examples/02-boundaries-and-metadata.hvis`
