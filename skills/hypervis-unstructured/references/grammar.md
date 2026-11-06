# HyperVisual Unstructured Grammar

## Declaration

```yaml
Sketch[unstructured]:
  - layout:
      direction: LR
      algorithm: organic
  - Alpha[service]
  - Beta[service]
  - Alpha --> Beta: "calls"
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations. Edges use `-->`, `<--`, or `<-->`. Diagram-wide layout settings belong in a top-level `layout:` list item.

## Type-Specific Notes

- Node types are open: pick readable annotations such as `Api[service]` or `Queue[queue]`.
- Grouping uses container nodes (for example `group`, `container`). List members as child list items. Do not use `children:` (removed in v0.1.0) or the legacy `group` property.

## Nesting

Nest nodes under a container by indenting them as list items in the container body.

## Labels and Properties

Use `- label: "..."` as a list item when the container body mixes labels with children. Visual styling belongs under `style:`; sizes often use `layout:` with `width` and `height`. Edge styling uses `style:` on the edge mapping.
