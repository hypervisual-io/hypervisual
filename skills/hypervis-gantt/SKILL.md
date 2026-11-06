---
name: hypervis-gantt
description: Author, edit, validate, render, and troubleshoot HyperVisual `gantt` diagrams. Use for Project plans, timelines, milestones, resources, dependencies, lanes, groups, deadlines, and critical path views. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual Gantt

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need schedule, dates, durations, resources, milestones, dependencies, and progress.
- You need a timeline/table render rather than a node-link graph.

## Avoid This Diagram Type When

- You need a generic process without calendar semantics; use flowchart or activity.

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
- `references/examples/01-basic-tasks.hvis`
- `references/examples/02-groups-milestones-resources.hvis`
- `references/examples/03-calendars-dependencies-critical-path.hvis`
