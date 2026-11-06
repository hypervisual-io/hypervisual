# HyperVisual Sequence Vocabulary

## Diagram Type

The body must be a YAML list:

```yaml
Example[sequence]:
  - A[actor]
  - B[service]
  - A --> B: "ping"
```

## Valid Node Types

- `actor`
- `participant`
- `lifeline`
- `service`
- `server`
- `database`
- `component`
- `object`
- `system`

## Valid Edge Types

- `message`
- `sync`
- `call`
- `async`
- `reply`
- `create`
- `destroy`
- `found`
- `lost`
- `self`

## Vocabulary Guidance

Use the vocabulary above exactly unless this document says the type is open/permissive. When the validator is strict for this type, unknown node or edge types can fail validation.
