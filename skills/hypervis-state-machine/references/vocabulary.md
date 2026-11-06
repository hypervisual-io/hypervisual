# HyperVisual State Machine Vocabulary

## Diagram Type

```yaml
Example[state-machine]:
  - initial --> Only
  - Only[state]
  - Only --> final:
      trigger: "done"
```

## Valid Node Types

- `state`
- `composite-state`
- `region`
- `initial`
- `final`
- `choice`
- `junction`
- `fork`
- `join`
- `entry-point`
- `exit-point`
- `terminate`
- `history`

## Valid Edge Types

- `transition`

## Vocabulary Guidance

Use the vocabulary above exactly unless this document says the type is open/permissive. When the validator is strict for this type, unknown node or edge types can fail validation.
