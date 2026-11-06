# HyperVisual State Machine Properties

## Diagram Properties

| Name | Type | Meaning |
|---|---|---|
| `layout` | object | Diagram-wide layout: `direction` (TB \| LR \| RL \| BT), `rank_gap`, `node_gap`. |

## Node Properties

| Name | Type | Meaning |
|---|---|---|
| `label` | string | Display label. |
| `layout` | object | Per-node `width`, `height`, or nested layout hints. |
| `entry_action` | string | Entry behavior. |
| `do_activity` | string | Ongoing state activity. |
| `exit_action` | string | Exit behavior. |
| `internal_transitions` | list | Internal transitions with `trigger`, `guard`, `action`. |
| `deferred` | list[string] | Deferred events. |
| `regions` | mapping | Orthogonal regions (region name → list body). |

Nesting: list child states and transitions under `composite-state` as items. Do not use a `children` property key.

## Edge Properties

| Name | Type | Meaning |
|---|---|---|
| `trigger` | string | Event that triggers the transition. |
| `guard` | string | Guard condition. |
| `action` | string | Transition action. |
| `label` | string | Rendered transition label. |
| `completion` | boolean | Completion transition flag. |

## Property Rules

- Unknown properties may fail validation on strict diagram types.
- Use quoted strings for labels or descriptions containing punctuation, colons, dates, or symbols.
- Prefer explicit booleans (`true`/`false`) for boolean fields.
- Prefer stable ids where the diagram type supports id-like properties.
