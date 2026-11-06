---
name: hypervis-flowchart
description: Author, edit, validate, render, and troubleshoot HyperVisual `flowchart` diagrams. Use for Generic directed process flows with decisions, stages, nested groups, and readable domain-specific node kinds. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual Flowchart

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need a directed process or decision flow.
- The node vocabulary should remain flexible but the graph should be structured.
- You need nested process groups with directed layout.

## Avoid This Diagram Type When

- You need UML activity semantics such as object flows, pins, partitions, forks, and joins.
- You need a timeline; use Gantt.

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
- `references/examples/01-process-flow.hvis`
- `references/examples/02-nested-groups-and-styling.hvis`
