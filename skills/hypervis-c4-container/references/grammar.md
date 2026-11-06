# HyperVisual C4 Container Grammar

## Declaration

```yaml
Checkout[c4-container]:
  - Shopper[person]: "Uses checkout"
  - Checkout[software-system]:
      scope: true
      description: "Coordinates cart and payment"
  - CheckoutBoundary[system-boundary]:
      - label: "Checkout Software System"
      - WebApp[container]:
          description: "Checkout UI"
      - Api[container]:
          description: "Checkout API"
  - Shopper --> WebApp: "Submits order"
  - WebApp --> Api: "Sends commands"
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations. Edges use `-->`, `<--`, or `<-->`.

## Type-Specific Notes

- Mark exactly one `software-system` with `scope: true` (the system whose containers you are diagramming).
- Place containers and databases that belong to that system inside a single `system-boundary` as nested list items.

## Nesting

Nest containers under `system-boundary` as list items. Do not use `children:` (removed in v0.1.0); nest with `-` list items only.

## Labels and Properties

A scalar string after a node colon becomes a node description. A scalar string after an edge colon becomes an edge label. Mapping values become structured properties and should be preferred for detailed diagrams.
