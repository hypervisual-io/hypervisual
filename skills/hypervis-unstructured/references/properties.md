# HyperVisual Unstructured Properties

## Diagram Properties

| Name | Type | Meaning |
|---|---|---|
| `layout` | object | Top-level `algorithm` (organic, force, …), `direction` (TB \| LR \| RL \| BT), `rank_gap`, `node_gap`. |

## Node Properties

| Name | Type | Meaning |
|---|---|---|
| `description` | string | Short description. |
| `label` | string | Display label; often as a list item `- label: "..."` in group bodies. |
| `links` | list/object | External links attached to the node. |
| `refs` | list | Source references or related `.hvis` files. |
| `layout` | object | Sizing and layout: `width`, `height`, nested `direction` or gaps when supported. |
| `style` | object | Visual styling: `shape`, `fill`, `stroke`, `stroke_width`, `text`, `line`, `dash`, `opacity`. |
| `icon` | string | Renderer icon name. |
| `layout_only` | boolean | Affinity or layout helper group. |

For groups, nest child nodes as list items. Do not use `children:` (removed in v0.1.0).

## Edge Properties

| Name | Type | Meaning |
|---|---|---|
| `label` | string | Relationship label. |
| `style` | object | `line`, `stroke`, `stroke_width`, `dash`, `opacity`. |
| `links` | list/object | External links attached to the edge. |

## Property Rules

- Unknown properties may fail validation on strict diagram types.
- Use quoted strings for labels or descriptions containing punctuation, colons, dates, or symbols.
- Prefer explicit booleans (`true`/`false`) for boolean fields.
- Prefer stable ids where the diagram type supports id-like properties.
