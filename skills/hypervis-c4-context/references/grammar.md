# HyperVisual C4 Context Grammar

## Declaration

```yaml
LearningPlatform[c4-context]:
  - Student[person]: "Uses the platform"
  - LearningPlatform[system]:
      scope: true
      description: "Delivers online courses"
  - VideoProvider[system, external]: "Video streaming"
  - Student --> LearningPlatform: "Views lessons"
  - LearningPlatform --> VideoProvider: "Requests playback"
```

## Shared HyperVisual Grammar

All HyperVisual diagrams are YAML. A file contains exactly one top-level mapping key with a bracketed diagram type. The top-level value is a YAML list. Node types use bracket annotations. Edges use `-->`, `<--`, or `<-->`.

## Type-Specific Notes

- Mark exactly one primary `software-system` or `system` with `scope: true`.
- Group related systems with `system-boundary` or `enterprise-boundary`; nest contained systems as list items inside the boundary.

## Nesting

Nest systems inside boundaries as list items. Do not use `children:` (removed in v0.1.0); nest with `-` list items only.

## Labels and Properties

A scalar string after a node colon becomes a node description. A scalar string after an edge colon becomes an edge label. Mapping values become structured properties and should be preferred for detailed diagrams.
