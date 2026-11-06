# HyperVisual C4 Code Grammar

## Declaration

```yaml
CheckoutPersistenceCode[c4-code]:
  - Scoped[component]:
      scope: true
      description: "Component in scope"
  - PersistencePackage[package]:
      - SaveRow[function]: "Persists rows"
  - Scoped --> SaveRow:
      type: dependency
      label: "Uses"
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations. Edges use `-->`, `<--`, or `<-->`.

## Type-Specific Notes

- Mark exactly one in-scope component with `scope: true`.
- Use packages and `component-boundary` nodes to group classes, modules, and records.
- Class-like members use the same string member convention as class diagrams.

## Nesting

Nest packages, boundaries, and class-like nodes as list items in the parent body. Do not use `children:` (removed in v0.1.0); nest with `-` list items only.

## Labels and Properties

A scalar string after a node colon becomes a node description. A scalar string after an edge colon becomes an edge label. Mapping values become structured properties and should be preferred for detailed diagrams.
