# HyperVisual Class Grammar

## Declaration

```yaml
OrderDomain[class]:
  - Order[class]:
    - "+ id: OrderId"
  - Customer[class]:
    - "+ name: String"
  - Order --> Customer:
      type: association
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations. Edges use `-->`, `<--`, or `<-->`.

## Type-Specific Notes

- Members can be declared as `members:` or as a direct string list under a class/interface/enum.
- Package nodes can contain nested classes, interfaces, enums, packages, and relationships.
- Member visibility commonly uses `+`, `-`, `#`, or `~`.

## Nesting

Nest classes, interfaces, enums, and other types as list items inside a `package` (or list items under structural nodes). Do not use `children:` (removed in v0.1.0); nest with `-` list items only.

## Labels and Properties

A scalar string after a node colon becomes a node description. A scalar string after an edge colon becomes an edge label. Mapping values become structured properties and should be preferred for detailed diagrams.
