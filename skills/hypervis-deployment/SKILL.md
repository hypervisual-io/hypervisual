---
name: hypervis-deployment
description: Author, edit, validate, render, and troubleshoot HyperVisual `deployment` diagrams. Use for infrastructure and runtime deployment topology across clouds, regions, networks, clusters, namespaces, workloads, data stores, routing, and the relationships between them. Assumes the `hypervis-cli` skill is installed for shared CLI commands, validation, rendering, and common .hvis grammar.
---

# HyperVisual Deployment

## Requirement

This skill assumes the `hypervis-cli` skill is installed. Use `hypervis-cli` for shared `.hvis` grammar, `hypervis help`, `hypervis validate`, `hypervis render`, scan, diff, and diagnostic workflow.

## Use This Diagram Type For

- You need to show where software runs: cloud/region/zone, networks, clusters, namespaces, nodes, and workloads.
- You need Kubernetes-style placement (deployments, pods, containers, jobs, cronjobs) and namespace-scoped resources.
- You need traffic and placement relationships such as routes-to, connects-to, mounts, uses-secret, and scheduled-on.

## Avoid This Diagram Type When

- You need logical system/container architecture rather than physical placement; use C4.
- You need security data-flow analysis with STRIDE threats; use threat-model.

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
- `references/examples/01-kubernetes-platform.hvis`
- `references/examples/02-cloud-neutral-provider.hvis`
- `references/examples/03-node-types-and-relationships.hvis`
