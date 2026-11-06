# HyperVisual State Machine Grammar

## Declaration

```yaml
TinySm[state-machine]:
  - initial --> Idle
  - Idle[state]
  - Idle --> Done:
      trigger: "finish"
  - Done[state]
  - Done --> final
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. States and pseudostates use bracket annotations where a type is required. Transitions use `-->` with structured properties for `trigger`, `guard`, `action`, and related fields.

## Type-Specific Notes

- Use `initial` and `final` as transition endpoints (for example `initial --> Draft`, `Paid --> final`).
- Composite states are list items under the parent `composite-state` body; substates and transitions are nested as list items, not under `children:` (removed in v0.1.0).
- Use `regions:` on composite states to model orthogonal regions (each region is a mapping of region name to a list body).
- Entry, do, and exit behavior use snake_case keys such as `entry_action`, `do_activity`, and `exit_action`.
- Internal transitions and deferred events use `internal_transitions` and `deferred` on states when needed.

## Nesting

Nest substates and inner transitions as YAML list items under the composite state's body. The removed `children` keyword is not supported.

## Labels and Properties

A scalar string after a state colon can serve as a description. Mapping values become structured properties and should be preferred for detailed diagrams.
