# Diagram Grammar

HyperVisual source is YAML plus a small semantic layer. YAML owns indentation,
strings, comments, maps, and lists. HyperVisual interprets the YAML tree into a
diagram with a name, a type, diagram-level directives, nodes (which may nest),
and edges.

When this reference and the installed binary disagree, the binary wins: its
`HVIS-PARSE-001` messages state the current rule (for example "the 'children:'
keyword was removed" or "'fill' must be nested under 'style:'").

## Document Shape

A file is one YAML mapping with exactly one key, the diagram declaration
`Name[type]`, whose value is a list:

```yaml
Login[sequence]:
  - Browser[actor]
  - API[service]
  - sync Browser -> API: "POST /login"
```

Rules:

- The top level must be a mapping with exactly one string key.
- That key must carry a `[type]` annotation.
- Its value must be a YAML list. Every diagram item is a list item.

Invalid (no type annotation):

```text
Login:
  - Browser[actor]
```

Invalid (two diagrams in one file):

```text
One[sequence]:
  - A[actor]
Two[sequence]:
  - B[actor]
```

## Bracket Annotations

```text
Name[type]
Name[type, annotation, annotation]
```

The first segment inside the brackets is the type; the rest are annotations
such as `scope` or `external`. Name, type, and every comma-separated segment
must be non-empty, so `[system]`, `Customer[]`, `Customer[system,]`, and
`Customer[, external]` are all invalid.

```yaml
Checkout[c4-context]:
  - Shopper[person]: "Places orders"
  - Checkout[software-system, scope]: "Retail checkout platform"
  - Payments[external-software-system, external]: "Card payment provider"
  - Shopper --> Checkout: "Places orders"
  - Checkout --> Payments: "Authorizes payments"
```

## Diagram Types

The diagram type is the annotation on the top-level key. Built-in types are
`activity`, `c4-context`, `c4-container`, `c4-component`, `c4-code`, `class`,
`deployment`, `flowchart`, `gantt`, `sequence`, `state-machine`,
`threat-model`, and `unstructured` (see [diagram-types.md](./diagram-types.md)).
Any other type fails validation unless you pass `--type-path <file.py>`.

## Nodes

A node is a list item whose key is `Name[type]`. Its body takes one of four
forms.

Bare node:

```yaml
- Browser[actor]
```

Scalar body, which becomes the description:

```yaml
- Browser[actor]: "Runs the user session"
```

Mapping body, for properties only:

```yaml
- API[container]:
    description: "Public API"
    technology: "Rust"
    links:
      docs: "https://example.test/api"
```

List body, for nodes that contain children (containers, boundaries, groups,
packages, lanes). Child nodes and edges are written directly as list items:

```yaml
- CheckoutBoundary[system-boundary]:
    - label: "Checkout"
    - WebApp[container]:
        description: "Customer UI"
        technology: "React"
    - API[container]:
        description: "Backend API"
        technology: "Rust"
    - WebApp --> API:
        label: "Submits orders"
        protocol: "HTTPS"
```

Rules for node bodies:

- There is no `children:` key. It was removed and is a parse error.
- A mapping body may not contain nested `Name[type]` or `A --> B` keys; to nest,
  switch the body to a list.
- In a list body, a single-key item such as `- label: "Checkout"` or
  `- layout: {...}` is a property of the parent when the key is a recognized
  node property (see the table below). Any other single-key item becomes an
  untyped child node, so an unrecognized key there silently turns into a node.
- Edges declared inside a container are collected into the diagram's edge list;
  endpoints refer to node names anywhere in the diagram.

Keys recognized as property items in a list body:

| Diagram type | Keys |
|---|---|
| all types | `description`, `label`, `links`, `refs`, `members`, `layout`, `style` |
| `activity` | `actor`, `operation`, `behavior`, `signal` |
| C4 types | `technology`, `protocol`, `external`, `scope` |
| `class` | `abstract`, `stereotype`, `stereotypes`, `template_parameters` |
| `deployment` | `provider`, `platform`, `environment`, `badge`, `public`, `managed`, `encrypted`, `replicas`, `image`, `version`, `region`, `zone` |
| `flowchart` | `layout_only`, `show_title` |
| `gantt` | `start`, `end`, `date`, `duration`, `progress`, `resource`, `baseline_start`, `baseline_end`, `actual_start`, `actual_end`, `deadline`, `critical`, `capacity`, `depends_on` |
| `state-machine` | `entry_action`, `exit_action`, `do_activity`, `deferred`, `internal_transitions`, `type`, `regions` |
| `threat-model` | `threats`, `mitigations`, `encrypted`, `authenticated`, `trust`, `data_classification`, `controls` |
| `unstructured` | `layout_only` |

Property names are `snake_case` (`entry_action`, `data_classification`,
`baseline_start`, `source_role`). Hyphenated spellings are rejected or ignored
by the validators.

### Untyped Nodes

A mapping key without brackets that is not an edge, directive, or reserved key
becomes an untyped node:

```yaml
- ManualStep: "No bracket type"
```

`flowchart` and `unstructured` accept untyped nodes; typed validators usually
reject them.

## Layout and Style

Layout and visual styling live in two nested mappings, never as bare keys.

`layout:` holds `direction` (`LR`, `RL`, `TB`, `BT`), `rank_gap`, `node_gap`,
`edge_gap`, `lane_gap`, `algorithm` (unstructured only), and the node's own
`width`/`height`. Which keys apply depends on the type: `activity` uses gaps
only, `gantt` and `sequence` take no geometric layout keys.

`style:` holds `fill`, `stroke`, `stroke_width`, `text`, `muted_text`,
`opacity`, `dash`, `line` (`solid`, `dashed`, `dashed-border`), and `shape`.

At diagram level, `layout` is a list item of its own:

```yaml
Pipeline[flowchart]:
  - layout:
      direction: LR
      rank_gap: 120
  - Build[process]
  - Deploy[process]:
      style:
        fill: "#ecfdf5"
        stroke: "#059669"
      layout:
        width: 200
  - Build --> Deploy:
      label: "artifact"
      style:
        line: dashed
        stroke_width: 2
```

Bare `direction`, `rank_gap`, `node_gap`, `edge_gap`, `lane_gap`, or
`algorithm` items, and bare `fill`, `stroke`, `stroke_width`, `shape`, `color`,
`border`, `text`, `opacity`, or `dash` keys on a node, are parse errors. On
edges, `color`, `stroke`, `stroke_width`, `width`, `dash`, and `opacity` must be
under `style:`. An edge's `direction` property stays a plain semantic property
(for example deployment `ingress`/`egress`).

## Edges

HyperVisual recognizes three generic arrows:

| Source | Parsed endpoints | Direction |
|---|---|---|
| `A --> B` | from `A`, to `B` | forward |
| `A <-- B` | from `B`, to `A` | reverse |
| `A <--> B` | from `A`, to `B` | bidirectional |

An edge value is either a scalar label or a property mapping:

```yaml
- A --> B: "message"
- A --> B:
    label: "message"
    type: calls
    links:
      ticket: "AUTH-401"
```

`label`, `links`, and `style` are special; other keys are edge properties that
the diagram type validates (`type`, `protocol`, `trigger`, and so on).

Not every type accepts every arrow. `gantt` rejects arrow edges entirely (use
`depends_on:` on the task), and `threat-model` rejects bidirectional flows.

## Sequence Messages

Sequence diagrams add message-sort prefixes, written with `->`:

```yaml
Checkout[sequence]:
  - Browser[actor]
  - API[service]
  - Worker[service]
  - Session[object]
  - sync Browser -> API: "POST /checkout"
  - create API -> Session: "new session"
  - async API -> Worker: "enqueue"
  - self API -> API: "validate"
  - reply API -> Browser: "202 Accepted"
  - destroy API -> Session: "expire"
  - found * -> API: "timer fired"
  - lost Worker -> *: "metric dropped"
```

Sort words: `sync`/`call`, `async`, `reply`/`return`, `create`,
`destroy`/`delete`, `found`, `lost`, and `self`. A `reply` goes from the
replier to the caller. `found` and `lost` use `*` for the off-diagram endpoint.

Directives are plain string items: `activate X`, `deactivate X`, `destroy X`,
`note over X: "..."` (also `note over A, B`), `note left of X: "..."`, and
`note right of X: "..."`.

Combined fragments wrap the messages they contain:

```yaml
Lookup[sequence]:
  - API[service]
  - Cache[service]
  - DB[database]
  - alt "cache hit":
      - sync API -> Cache: "get"
      - reply Cache -> API: "value"
  - else "cache miss":
      - sync API -> DB: "select"
      - reply DB -> API: "row"
  - loop "for each key":
      - sync API -> Cache: "refresh"
```

Fragment operators: `alt`, `else`, `opt`, `loop`, `par`, `break`, `critical`,
`neg`, `assert`, `strict`, `seq`, `ignore`, `consider`, and `ref`.

## State-Machine Regions

Orthogonal regions use a `regions:` mapping of region names to lists:

```yaml
Order[state-machine]:
  - initial --> Processing
  - Processing[composite-state]:
      regions:
        Payment:
          - Authorizing[state]
          - Captured[state]
          - Authorizing --> Captured:
              trigger: "capture"
        Fulfillment:
          - Picking[state]
          - Shipped[state]
          - Picking --> Shipped:
              trigger: "ship"
```

Each region becomes a child node of type `region`.

## Members

Class-like nodes take member strings either under `members:` or as a plain list
body:

```yaml
Accounts[class]:
  - User[class]:
      members:
        - "+id: String"
        - "+role: Role"
        - "+changeEmail(email: String): void"
  - Role[class]:
      - "+name: String"
  - User --> Role:
      type: association
```

## Links

Links attach to nodes or edges, as a mapping:

```yaml
links:
  source: "src/auth.rs:42"
  docs: "https://example.test/auth"
```

or as a list with optional labels:

```yaml
links:
  - kind: source
    value: "src/auth.rs:42"
  - kind: ticket
    value: "AUTH-401"
    label: "Login hardening"
```

## Diagram-Level Directives

Some single-key list items configure the diagram instead of creating nodes:

- all types: `layout`, `sources`, `test`, `theme`, `overlay`
- `gantt`: `timeline`, `calendar`, `dependencies`, `defaults`, `markers`,
  `sort`, `critical_path`, `columns`
- `threat-model`: `threats`
- `class`: `context` (scanner metadata)

`sources` declares external data files:

```yaml
Backlog[gantt]:
  - sources:
      - name: tasks
        file: backlog.xlsx
        sheet: Sprint 3
  - BuildAPI[task]:
      start: 2026-06-10
      duration: 5d
```

## YAML Notes

Quote values that contain YAML-sensitive characters such as `:` or `#`:

```yaml
- API --> Worker: "event: order.created"
```

Keep every declaration in list form. It preserves order and allows repeated
edges between the same pair of nodes; duplicate mapping keys do not.

```yaml
- API --> Worker: "create"
- API --> Worker: "cancel"
```
