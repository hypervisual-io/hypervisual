# HyperVisual Gantt Properties

## Diagram Properties

| Name | Type | Meaning |
|---|---|---|
| `timeline` | object | Timeline configuration: `scale`, `today`. |
| `calendar` | object | Calendar configuration: timezone, work week, holidays. |
| `markers` | list | Timeline markers with date/label/name/color. |
| `dependencies` | object | Dependency display configuration (when supported). |

## Node Properties

| Name | Type | Meaning |
|---|---|---|
| `start` | date/datetime | Task/group/lane start. |
| `end` | date/datetime | Task/group/lane end. |
| `finish` | date/datetime | Alias for end. |
| `duration` | duration | Task duration. |
| `date` | date/datetime | Milestone date. |
| `progress` | 0..1, 0..100, or percent | Task progress. |
| `resource` | string | Single resource. |
| `resources` | list[string] | Multiple resources. |
| `baseline_start` | date/datetime | Baseline start. |
| `baseline_end` | date/datetime | Baseline end. |
| `deadline` | date/datetime | Deadline marker. |
| `critical` | boolean | Marks critical work. |
| `capacity` | number | Resource capacity. |
| `depends_on` | list | Predecessors: task names or maps with `task`, `type`, `lag`, `lead`, `critical`, etc. |

Nesting: under `group` or `lane`, list child tasks and milestones as list items. Do not use a `children` property key.

## Property Rules

- Unknown properties may fail validation on strict diagram types.
- Use quoted strings for labels or descriptions containing punctuation, colons, dates, or symbols.
- Prefer explicit booleans (`true`/`false`) for boolean fields.
- Prefer stable ids where the diagram type supports id-like properties.
