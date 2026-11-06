# HyperVisual Activity Grammar

## Declaration

```yaml
SupportEscalation[activity]:
  - start[initial-node]
  - OpenTicket[action]
  - done[activity-final-node]
  - start --> OpenTicket
  - OpenTicket --> done
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations. Edges use `-->`, `<--`, or `<-->`.

## Type-Specific Notes

- Use `initial` and `final` aliases for common endpoints.
- Swimlanes, partitions, and regions are container nodes: nest child actions and control nodes as **list items** under the parent (`- ChildName[type]`).
- Use `type: object-flow` for object/pin data movement.
- Use `type: control-flow` for control sequencing.

## Nesting

Nest child nodes as list items in the parent node's body. Do not use `children:` (removed in v0.1.0); nest with `-` list items only.

## Labels and Properties

A scalar string after a node colon becomes a node description. A scalar string after an edge colon becomes an edge label. Mapping values become structured properties and should be preferred for detailed diagrams.
