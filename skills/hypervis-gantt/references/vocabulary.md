# HyperVisual Gantt Vocabulary

## Diagram Type

Diagram body must be a list:

```yaml
Example[gantt]:
  - timeline:
      scale: day
      today: 2026-08-01
  - OneTask[task]:
      start: 2026-08-01
      end: 2026-08-03
```

## Valid Node Types

- `task`
- `milestone`
- `group`
- `lane`
- `resource`

## Dependencies

Dependencies are not edges. Use `depends_on:` on a task or milestone with a list of task names or structured entries (`task:`, `type:`, `lag:`, etc.).

## Vocabulary Guidance

Use the vocabulary above exactly unless this document says the type is open/permissive. When the validator is strict for this type, unknown node types can fail validation.
