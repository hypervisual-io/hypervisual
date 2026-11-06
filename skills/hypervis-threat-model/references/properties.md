# HyperVisual Threat Model Properties

## Diagram Properties

| Name | Type | Meaning |
|---|---|---|
| `threats` | list | Top-level authored threats targeting elements or flows. |

## Node Properties

| Name | Type | Meaning |
|---|---|---|
| `description` | string | Short description rendered or used by validators. |
| `label` | string | Display label override. |
| `links` | list/object | External links attached to the node. |
| `refs` | list | Source references or related `.hvis` files. |
| `threats` | list | Threats scoped to this element. |
| `trust_level` | string | Trust level for external entities. |
| `technology` | string | Technology for processes. |
| `privilege_level` | string | Privilege level for processes. |
| `controls` | list[string] | Security controls. |
| `encrypted` | boolean | Encryption status for data stores. |
| `data_classification` | enum | Sensitivity (for example `pii`, `confidential`, `internal`). |

Under a `trust-boundary`, nest child elements as list items in the body.

## Edge Properties

| Name | Type | Meaning |
|---|---|---|
| `label` | string | Data flow label. |
| `encrypted` | boolean | Whether the flow is encrypted. |
| `authenticated` | boolean | Whether the flow is authenticated. |
| `protocol` | string | Protocol used by the data flow. |
| `data` | string | Data carried by the flow. |
| `data_classification` | enum | Sensitivity of data in transit. |
| `threats` | list | Threats scoped to this flow. |
| `bidirectional` | boolean | Whether the flow is bidirectional. |

## Property Rules

- Unknown properties may fail validation on strict diagram types.
- Use quoted strings for labels or descriptions containing punctuation, colons, dates, or symbols.
- Prefer explicit booleans (`true`/`false`) for boolean fields.
- Prefer stable ids where the diagram type supports id-like properties.
