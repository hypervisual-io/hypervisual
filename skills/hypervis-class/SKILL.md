---
name: hypervis-class
description: Author, edit, validate, render, and troubleshoot HyperVisual `class` diagrams. Use for UML class, interface, enum, and package diagrams, including scanner-generated code structure. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual Class

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need static object/code structure with classes, interfaces, enums, packages, members, and relationships.
- You need association details such as roles, multiplicity, navigability, composition, or aggregation.
- You want to visualize scanner-generated model relationships.

## Avoid This Diagram Type When

- You need C4 code-level architecture inside a component; use hypervis-c4-code.
- You need call order; use sequence.

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
- `references/examples/01-members-interfaces-enums.hvis`
- `references/examples/02-relationships-multiplicity.hvis`
- `references/examples/03-stereotypes-templates-association.hvis`
