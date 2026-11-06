# HyperVisual Threat Model Grammar

## Declaration

```yaml
MinimalTm[threat-model]:
  - Internet[trust-boundary]:
      - User[external-entity]: "Browser"
  - App[trust-boundary]:
      - Api[process]: "Handles requests"
  - User --> Api:
      label: "HTTPS"
      encrypted: true
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Elements use bracket annotations. Data flows use `-->`, `<--`, or `<-->` with properties such as `encrypted`, `authenticated`, and `data_classification`.

## Type-Specific Notes

- Model trust boundaries as container nodes. List nested processes, data stores, and external entities as YAML list items inside the boundary body. Do not use `children:` (removed in v0.1.0).
- Authored threats can appear in `threats:` lists on nodes, edges, or at the diagram level depending on your scenario.

## Nesting

Nest elements inside a boundary by listing them as child items. The removed `children` keyword is not supported.

## Labels and Properties

A scalar string after a node colon becomes a description. Mapping values become structured properties and should be preferred for detailed diagrams.
