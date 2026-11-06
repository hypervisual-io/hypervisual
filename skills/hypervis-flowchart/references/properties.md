# HyperVisual Flowchart Properties

## Diagram Properties

| Name | Type | Meaning |
|---|---|---|
| `layout` | object | Diagram-wide layout: `direction` (TB \| LR \| RL \| BT), `rank_gap`, `node_gap`, and other keys accepted by the renderer. |

## Node Properties

| Name | Type | Meaning |
|---|---|---|
| `description` | string | Short description rendered or used by validators. |
| `label` | string | Display label override. |
| `links` | list/object | External links attached to the node. |
| `refs` | list | Source references or related `.hvis` files. |
| `layout` | object | Per-node layout such as `direction`, `rank_gap`, `node_gap`, `width`, `height`. |
| `style` | object | Visual styling: `fill`, `stroke`, `stroke_width`, `line` (for example dashed edges on flows), etc. |
| `shape` | string | Renderer shape override where supported. |
| `layout_only` | boolean | Marks a layout helper or grouping node. |

Nesting: list child nodes and edges directly under a container body. Do not use a `children` property key.

## Edge Properties

| Name | Type | Meaning |
|---|---|---|
| `label` | string | Branch or flow label. |
| `style` | object | Visual style: `line`, `stroke`, `stroke_width`, etc. |
| `links` | list/object | External links attached to the edge. |

## Property Rules

- Unknown properties may fail validation on strict diagram types.
- Use quoted strings for labels or descriptions containing punctuation, colons, dates, or symbols.
- Prefer explicit booleans (`true`/`false`) for boolean fields.
- Prefer stable ids where the diagram type supports id-like properties.
