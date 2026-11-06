---
name: hypervis-state-machine
description: Author, edit, validate, render, and troubleshoot HyperVisual `state-machine` diagrams. Use for UML-style state machines with states, transitions, composite states, regions, history, and pseudostates. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual State Machine

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need lifecycle/state behavior rather than process steps.
- Events, guards, actions, entry/do/exit behavior, and composite states matter.
- You need validation of pseudostate and transition rules.

## Avoid This Diagram Type When

- You need ordered interactions between participants; use sequence.
- You need business process flow; use activity or flowchart.

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
- `references/examples/01-basic-lifecycle.hvis`
- `references/examples/02-pseudostates-composite.hvis`
- `references/examples/03-regions-internal-transitions.hvis`
