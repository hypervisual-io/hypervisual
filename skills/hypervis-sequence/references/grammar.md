# HyperVisual Sequence Grammar

## Declaration

```yaml
MinimalSequence[sequence]:
  - Client[actor]
  - Service[service]
  - Client --> Service: "request"
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Lifeline types use bracket annotations. Messages use `-->`, `<--`, `<-->`, or explicit directives such as `sync`, `reply`, and `async`.

## Type-Specific Notes

- Declare lifelines before messages where possible.
- Generic arrows are supported: `A --> B`, `A <-- B`, and `A <--> B`.
- Sequence directives include `sync`, `call`, `async`, `reply`, `create`, `destroy`, `found`, `lost`, and `self`.
- Lifecycle directives include `activate X`, `deactivate X`, and `destroy X`.
- Notes use `note over X`, `note left of X`, or `note right of X`.
- Fragments use `alt`, `else`, `opt`, `loop`, `par`, `break`, `critical`, `neg`, `assert`, `strict`, `seq`, `ignore`, `consider`, and `ref` list items.

## Nesting

Fragments and similar constructs nest using normal YAML list structure under the fragment head item. Do not use `children:` (removed in v0.1.0) for lifelines or groups.

## Labels and Properties

A scalar string after a node colon becomes a node description. A scalar string after an edge colon becomes a message label. Mapping values become structured properties and should be preferred for detailed diagrams.
