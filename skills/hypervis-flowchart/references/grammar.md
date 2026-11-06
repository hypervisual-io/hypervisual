# HyperVisual Flowchart Grammar

## Declaration

```yaml
ReleaseCheck[flowchart]:
  - layout:
      direction: LR
      rank_gap: 120
  - Start[process]:
      label: "Start work"
  - Done[terminal]:
      label: "Complete"
  - Start --> Done: "finish"
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations. Edges use `-->`, `<--`, or `<-->`. Diagram-wide layout settings belong in a top-level `layout:` mapping item, not as bare keys on the diagram list.

## Type-Specific Notes

- Use readable domain-specific node types, for example `Review[decision]` or `Deploy[process]`.
- To nest process groups, put child nodes and edges as list items directly under the parent group node body. Do not use `children:` (removed in v0.1.0).
- Use labels on decision outgoing edges for branch meaning.
- Put colors and line styles under `style:` on nodes and edges.

## Nesting

Under a container node (for example `group`), nest child nodes and edges as YAML list items. `children:` was removed in v0.1.0 and is a parse error.

## Labels and Properties

A scalar string after a node colon becomes a node description. A scalar string after an edge colon becomes an edge label. Mapping values become structured properties and should be preferred for detailed diagrams.
