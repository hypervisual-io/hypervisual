---
name: hypervis-threat-model
description: Author, edit, validate, render, and troubleshoot HyperVisual `threat-model` diagrams. Use for STRIDE-compatible data-flow diagrams with trust boundaries, data stores, processes, external entities, and authored threats. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual Threat Model

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need a security data-flow diagram.
- You need trust boundary crossing checks, encryption checks, and authored STRIDE threats.
- You need threat status, severity, mitigations, and data classification.

## Avoid This Diagram Type When

- You need general architecture without security-specific semantics; use C4 or unstructured.

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
- `references/examples/01-boundaries-and-data-flows.hvis`
- `references/examples/02-nested-boundaries-and-controls.hvis`
- `references/examples/03-auth-webhook-and-queue.hvis`
