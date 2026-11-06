# HyperVisual Threat Model Authoring Guide

## Purpose

STRIDE-compatible data-flow diagrams with trust boundaries, data stores, processes, external entities, and authored threats.

## Choose This Type When

- You need a security data-flow diagram.
- You need trust boundary crossing checks, encryption checks, and authored STRIDE threats.
- You need threat status, severity, mitigations, and data classification.

## Prefer Another Type When

- You need general architecture without security-specific semantics; use C4 or unstructured.

## Minimal Shape

```yaml
Example[threat-model]:
  - Public[trust-boundary]:
      - Browser[external-entity]: "User device"
  - AppZone[trust-boundary]:
      - Web[process]: "Web tier"
  - Browser --> Web:
      label: "HTTPS"
      encrypted: true
```

## Production Pattern

- Declare important nodes before edges.
- Use stable names because HyperVisual identity is name-based.
- Add labels on relationships where the validator or reader benefits from intent.
- Prefer structured properties over overloaded labels when a property exists.
- Keep examples valid by running `hypervis validate`.
- Use `hypervis help render` before assuming installed render flags.

## Common Mistakes

- Referencing an undeclared edge endpoint.
- Mixing a diagram type's vocabulary with a lower-level or unrelated diagram type.
- Using a render target as source syntax. Render size belongs on the CLI, not in `.hvis`.
- Relying on stale command flags instead of `hypervis help <command>`.
