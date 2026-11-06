---
name: hypervis-unstructured
description: Author, edit, validate, render, and troubleshoot HyperVisual `unstructured` diagrams. Use for Permissive freeform diagrams, concept maps, dependency webs, ownership maps, and quick sketches. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual Unstructured

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need readable topology but not a strict semantic model.
- Node types are domain-specific or experimental.
- You want rich visual styling and nested groups without strict validation.

## Avoid This Diagram Type When

- You need C4, UML, STRIDE, or Gantt-specific validation.
- A strict diagram type exists for the domain and should catch mistakes.

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
- `references/examples/01-freeform-groups.hvis`
- `references/examples/02-styling-and-edge-styles.hvis`
- `references/examples/03-layout-affinity.hvis`
