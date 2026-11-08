# Overlays

An overlay highlights a named path through a diagram. Declare overlays in a
top-level `overlay:` mapping next to the diagram declaration (not as a list item
inside the diagram body):

```yaml
Shop[c4-container]:
  - Customer[person]: "Browses and pays"
  - WebApp[container]: "Storefront"
  - Api[container]: "Orders and payments"
  - PaymentProvider[external-software-system]: "Card network"
  - Customer --> WebApp: "Browses"
  - WebApp --> Api: "Submits orders"
  - Api --> PaymentProvider: "Charges cards"
overlay:
  PaymentPath:
    path: [Customer, WebApp, Api, PaymentProvider]
    color: red              # optional: named, #hex, or rgb(); default #FF2D2D
    note: "PCI scope"         # optional: legend caption
```

## Semantics

- `path` is an ordered list of node names (resolved like edge endpoints). In a
  state machine, qualify names that exist in several composite states
  (`Billing.Idle`).
- Each path node is outlined in the overlay color, and so is every edge between
  consecutive path nodes. Forward edges (`A --> B`) win when present; otherwise
  reverse edges are used. All parallel edges between a pair are highlighted. A
  one-node path highlights just that node.
- Everything not on a drawn overlay is dimmed. Overlays with a `note` get a
  legend entry below the diagram.
- When several overlays are drawn, an element on multiple paths takes the color
  of the overlay declared last in the file.
- `validate` checks overlays; `expand` keeps them (JSON `overlays` array,
  `--format hvis` prints the `overlay:` block).
- Supported on every built-in type except `gantt`. On sequence diagrams the path
  names participants; messages between consecutive participants are the edges.

## Render and MCP

By default, `render` draws every declared overlay.

```bash
hypervis render diagram.hvis --overlay PaymentPath -o path.png
hypervis render diagram.hvis --overlay PathA --overlay PathB -o both.png
hypervis render diagram.hvis --no-overlay -o plain.png
```

MCP `hvis_render`: `overlays: ["PaymentPath"]` (repeatable names) or
`no_overlay: true` (not both).

## Diagnostics

All overlay codes are errors:

| Code | Meaning |
|---|---|
| `HVIS-OVERLAY-001` | Malformed `overlay:` block or overlay entry |
| `HVIS-OVERLAY-002` | `path` missing, empty, or not a list of names |
| `HVIS-OVERLAY-003` | `color` is not a color |
| `HVIS-OVERLAY-004` | Path item is not a node (unknown or ambiguous name) |
| `HVIS-OVERLAY-005` | No edge joins two consecutive path nodes |
| `HVIS-OVERLAY-006` | Diagram type does not support overlays (`gantt`) |
| `HVIS-OVERLAY-007` | `--overlay` / `overlays` names an undeclared overlay |
