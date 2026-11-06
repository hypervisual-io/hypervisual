---
name: hypervis-c4-code
description: Author, edit, validate, render, and troubleshoot HyperVisual `c4-code` diagrams. Use for C4 code-level diagrams showing classes, interfaces, functions, modules, and packages inside one component. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual C4 Code

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need code-level architecture inside one component.
- You want C4 context plus class-like structure and structural relationship validation.

## Avoid This Diagram Type When

- You only need pure UML/domain classes; use hypervis-class.
- You need component-level architecture; use hypervis-c4-component.

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
- `references/examples/01-modules-functions-tables.hvis`
- `references/examples/02-members-and-boundaries.hvis`
