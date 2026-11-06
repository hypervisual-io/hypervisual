# HyperVisual Threat Model Vocabulary

## Diagram Type

```yaml
Example[threat-model]:
  - Zone[trust-boundary]:
      - App[process]: "In-scope component"
```

## Valid Node Types

- `trust-boundary`
- `process`
- `data-store`
- `external-entity`

## Valid Edge Types

- `data-flow` (often implicit on `-->` between elements)

## Vocabulary Guidance

Use the vocabulary above exactly unless this document says the type is open/permissive. When the validator is strict for this type, unknown node or edge types can fail validation.
