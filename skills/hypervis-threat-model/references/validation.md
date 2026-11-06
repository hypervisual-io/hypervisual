# HyperVisual Threat Model Validation

## Main Rules

- Valid STRIDE categories: spoofing, tampering, repudiation, information-disclosure, denial-of-service, elevation-of-privilege.
- Valid severities: low, medium, high, critical.
- Valid statuses: open, mitigated, accepted.
- Cross-boundary flows should declare encryption and protocol/label.
- Sensitive data stores should declare `encrypted: true`.
- Elevated processes should declare controls.

## Repair Loop

1. Run `hypervis validate <file>`.
2. Read each diagnostic code, node, edge, and path.
3. Fix the source rather than suppressing diagnostics.
4. Rerun validation.
5. Render only after error and critical diagnostics are gone.

## Strict Mode

Use `hypervis validate <file> --strict` when producing best-practice examples or documentation diagrams. Strict mode may promote supported convention warnings.

## Threat entry diagnostics

Codes are `HVIS-TM-…` in current tooling; **hypervis v0.1.0** prints them as **`CODI-TM-…`**.

| Code | Severity | When |
|---|---|---|
| HVIS-TM-021 | critical | `threats` is not a list |
| HVIS-TM-022 | critical | threat item is not a mapping |
| HVIS-TM-023 | critical | unsupported `category` |
| HVIS-TM-024 | critical | missing `category` |
| HVIS-TM-025 | warning | unsupported `severity` |
| HVIS-TM-026 | warning | missing `severity` |
| HVIS-TM-027 | warning | `mitigated` without `mitigation` |
| HVIS-TM-028 | warning | unsupported `status` |
| HVIS-TM-029 | warning | missing `status` |
| HVIS-TM-030 | warning | `accepted` without `rationale` or `acceptance-rationale` |
| HVIS-TM-031 | warning | duplicate authored threat for same target and category |
| HVIS-TM-032 | critical | top-level threat references unknown element |
| HVIS-TM-033 | critical | top-level threat references unknown flow or `flow_id` |
| HVIS-TM-034 | critical | top-level threat missing target fields |
| HVIS-TM-072 | critical | top-level `from`/`to` matches multiple flows; use `flow_id` |

## Common Repairs

- Add missing node declarations for edge endpoints.
- Rename duplicate nodes or intentionally nest them where the type supports scope.
- Replace invalid node/edge types with vocabulary entries from `vocabulary.md`.
- Replace unsupported properties with entries from `properties.md`.
- Add relationship labels where the diagram type expects them.
