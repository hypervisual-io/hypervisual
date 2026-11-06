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

## Threat entries

Each item under any `threats:` list must be a **YAML mapping** (one object per list element), not a bare string.

Put `threats:` on the diagram, on an element (any non–trust-boundary node), or on a data-flow edge. The threat then targets that element or flow unless you override the target with the fields below (required for `threats:` placed directly on the diagram).

**Diagnostic codes:** validators use `HVIS-TM-…` (e.g. `HVIS-TM-022`).

| Field | Required | Values / form | Meaning |
|---|---|---|---|
| `category` | yes | `spoofing`, `tampering`, `repudiation`, `information-disclosure`, `denial-of-service`, `elevation-of-privilege` | STRIDE category |
| `severity` | expected | `low`, `medium`, `high`, `critical` | Risk level; omitting or invalid values yields a warning (`HVIS-TM-025` / `HVIS-TM-026`) |
| `status` | expected | `open`, `mitigated`, `accepted` | Lifecycle; omitting or invalid values yields a warning (`HVIS-TM-028` / `HVIS-TM-029`) |
| `title` | no | string | Short title |
| `description` | no | string | Longer text |
| `mitigation` | no | string | How the risk is reduced |
| `residual_risk` | no | string | Remaining risk after mitigation |
| `rationale` | no | string | Acceptance rationale (alias: `acceptance-rationale`) |
| `controls` | no | string or list of strings | Related controls |
| `assumptions` | no | string or list of strings | Assumptions |
| `tags` | no | string or list of strings | Tags |
| `id` | no | string | Optional id; if omitted, tooling synthesizes one in canonical output |
| `element` or `node` | for top-level threats | node name | Target element |
| `edge` | optional | `"From --> To"` (also `->` or `→`) | Target data flow by endpoints |
| `flow_id` | optional | string | Target the flow whose edge declares this `flow_id` |
| `from` + `to` | optional | node names | Target data flow by endpoints (use with `flow_id` if multiple edges share the same pair) |

**Rules**

- `mitigated` without `mitigation` → warning `HVIS-TM-027`.
- `accepted` without `rationale` or `acceptance-rationale` → warning `HVIS-TM-030`.
- Duplicate authored threat for the same resolved target and category → warning `HVIS-TM-031`.
- Top-level threats must specify a target (`element`, `node`, `edge`, `flow_id`, or `from`/`to`); missing target → `HVIS-TM-034`; unknown node or flow → `HVIS-TM-032` / `HVIS-TM-033`; ambiguous duplicate `from`/`to` without disambiguating `flow_id` → `HVIS-TM-072`.

**Example** (element-scoped threats on a process; `accepted` includes rationale):

```yaml
ThreatSnippet[threat-model]:
  - Tier[trust-boundary]:
      - WebhookApi[process]:
          threats:
            - category: tampering
              severity: high
              status: open
              title: "Replayed signed payloads"
              description: "Attacker captures and replays webhook requests."
            - category: elevation-of-privilege
              severity: medium
              status: accepted
              title: "Residual trust in partner accounts"
              description: "Compromised partner could send malicious events."
              rationale: "Accepted per vendor risk review; contract mandates key rotation and anomaly detection."
```

## Property Rules

- Unknown properties may fail validation on strict diagram types.
- Use quoted strings for labels or descriptions containing punctuation, colons, dates, or symbols.
- Prefer explicit booleans (`true`/`false`) for boolean fields.
- Prefer stable ids where the diagram type supports id-like properties.
