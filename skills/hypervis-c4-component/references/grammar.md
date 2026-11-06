# HyperVisual C4 Component Grammar

## Declaration

```yaml
CheckoutApiComponents[c4-component]:
  - CheckoutApi[container]:
      scope: true
      description: "API container in scope"
  - ApiBoundary[container-boundary]:
      - label: "Checkout API"
      - CartController[component]:
          description: "Handles HTTP requests"
  - WebApp[container]: "Web client"
  - WebApp --> CartController: "Invokes checkout"
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations. Edges use `-->`, `<--`, or `<-->`.

## Type-Specific Notes

- Mark exactly one `container` with `scope: true` (the container whose internals you are diagramming).
- Put sibling components inside a `container-boundary` as list items; external containers and systems stay as peers outside the boundary.

## Nesting

Nest components as list items under `container-boundary` (or the scoped container pattern your diagram uses). Do not use `children:` (removed in v0.1.0); nest with `-` list items only.

## Labels and Properties

A scalar string after a node colon becomes a node description. A scalar string after an edge colon becomes an edge label. Mapping values become structured properties and should be preferred for detailed diagrams.
