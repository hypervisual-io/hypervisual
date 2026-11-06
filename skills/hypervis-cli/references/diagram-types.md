# Diagram Type Reference

All diagram types share the grammar in [grammar.md](./grammar.md): child nodes
go directly in a node's list body, layout settings go under `layout:`, visual
settings go under `style:`, and property names are `snake_case`. Each type adds
its own vocabulary and validation rules. The diagram-specific `hypervis-<type>`
skills cover each type in depth.

## Sequence

```yaml
Login[sequence]:
  - Browser[actor]
  - API[service]
  - Worker[service]
  - Session[object]
  - sync Browser -> API: "POST /login"
  - activate API
  - create API -> Session: "new session"
  - async API -> Worker: "audit login"
  - self API -> API: "hash password"
  - reply API -> Browser: "200 OK"
  - deactivate API
  - found * -> Worker: "timer fired"
  - lost Worker -> *: "metric dropped"
  - destroy API -> Session: "expire"
```

Purpose: ordered interactions over time.

Lifeline types: `actor`, `participant`, `lifeline`, `service`, `server`,
`database`, `component`, `object`, `system`.

Messages use a sort prefix and `->`: `sync`, `async`, `reply`, `create`,
`destroy`, `found` (`* -> X`), `lost` (`X -> *`), and `self`. Directives are
`activate X`, `deactivate X`, `destroy X`, `note over X`, `note left of X`, and
`note right of X`.

Fragments wrap the messages they contain:

```yaml
Authorize[sequence]:
  - Browser[actor]
  - API[service]
  - note over Browser, API: "TLS session established"
  - sync Browser -> API: "GET /account"
  - alt "token valid":
      - reply API -> Browser: "200 account"
  - else "token expired":
      - reply API -> Browser: "401"
  - ref "RefreshToken(flow)":
      - sync Browser -> API: "POST /refresh"
```

Fragment operators: `alt`, `else`, `opt`, `loop`, `par`, `break`, `critical`,
`neg`, `assert`, `strict`, `seq`, `ignore`, `consider`, and `ref`.

Validation checks lifeline vocabulary, message endpoints, call/reply pairing,
fragments, notes, and lifecycle consistency. Layout places lifelines
horizontally and messages vertically in source order.

Examples:

- [01-basic-messages-lifecycle.hvis](../../hypervis-sequence/references/examples/01-basic-messages-lifecycle.hvis)
- [02-fragments-notes-refs.hvis](../../hypervis-sequence/references/examples/02-fragments-notes-refs.hvis)
- [03-parallel-and-boundary.hvis](../../hypervis-sequence/references/examples/03-parallel-and-boundary.hvis)

## Unstructured

```yaml
ServiceMap[unstructured]:
  - layout:
      algorithm: organic
      direction: LR
      node_gap: 60
  - API[service]:
      label: "Public API"
      icon: server
      style:
        shape: rect
        fill: "#f5f7ff"
        stroke: "#4f46e5"
        text: "#111827"
      layout:
        width: 220
        height: 90
  - Queue[queue]
  - Platform[group]:
      - Worker[service]
      - Store[database]
  - API --> Queue:
      label: "events"
      style:
        line: dashed
        stroke: "#6b7280"
        stroke_width: 2
  - Queue --> Worker: "consumes"
  - Worker --> Store: "writes"
```

Purpose: permissive freeform diagrams, concept maps, ownership maps, dependency
webs, and quick sketches. Node types are open; `group` and `container` nodes
hold children. `layout:` accepts `algorithm` (for example `organic` or
`force`), `direction`, `rank_gap`, and `node_gap`; `style:` accepts shapes such
as `pill`, `hexagon`, `cylinder`, `cloud`, `document`, and `person`.

Validation warns about malformed renderer options such as an invalid
`algorithm` or `direction` or negative sizes.

Examples:

- [01-freeform-groups.hvis](../../hypervis-unstructured/references/examples/01-freeform-groups.hvis)
- [02-styling-and-edge-styles.hvis](../../hypervis-unstructured/references/examples/02-styling-and-edge-styles.hvis)
- [03-layout-affinity.hvis](../../hypervis-unstructured/references/examples/03-layout-affinity.hvis)

## Flowchart

```yaml
ReleaseGate[flowchart]:
  - layout:
      direction: LR
      rank_gap: 180
  - Start[terminal]
  - Review[decision]
  - Fulfillment[group]:
      - layout:
          direction: TB
      - ReserveInventory[process]
      - PackOrder[process]
      - ReserveInventory --> PackOrder: "reserved"
  - Rejected[terminal]
  - Start --> Review: "submit"
  - Review --> ReserveInventory: "approved"
  - Review --> Rejected: "rejected"
```

Purpose: generic directed process flows. Any node type annotation is accepted,
so use readable kinds such as `terminal`, `process`, `decision`, or `document`.
Containers such as `group` take a list body with an optional `- layout:` item.

Validation checks direction values, duplicate nodes and edges, numeric layout
values, and layout-only nodes. Layout is directed and container-aware.

Examples:

- [01-process-flow.hvis](../../hypervis-flowchart/references/examples/01-process-flow.hvis)
- [02-nested-groups-and-styling.hvis](../../hypervis-flowchart/references/examples/02-nested-groups-and-styling.hvis)

## Activity

```yaml
Approval[activity]:
  - Start[initial]
  - Editorial[swimlane]:
      - Review[action]
      - Rework[action]
  - Approved[decision]
  - Draft[object]
  - Publish[action]
  - Done[activity-final]
  - Start --> Review
  - Review --> Draft:
      type: object-flow
  - Review --> Approved
  - Approved --> Publish:
      guard: "approved"
  - Approved --> Rework:
      guard: "changes requested"
  - Rework --> Review
  - Publish --> Done
```

Purpose: UML-style activity flows, object flows, partitions, and regions.

Node families:

- actions: actions, calls, accept/send signal variants
- objects: object nodes, pins, data stores, central buffers
- control: initial, final, flow-final, decision, merge, fork, join
- containers: partitions/swimlanes, interruptible regions, expansion regions

Edges default to control flow; set `type: object-flow` for object flows and
`guard:` for decision branches. Validation checks vocabulary, endpoints,
object/control flow combinations, decision fan-out, reachability, partitions,
pins, and regions.

Examples:

- [01-control-flow.hvis](../../hypervis-activity/references/examples/01-control-flow.hvis)
- [02-actions-pins-object-flow.hvis](../../hypervis-activity/references/examples/02-actions-pins-object-flow.hvis)
- [03-lanes-regions.hvis](../../hypervis-activity/references/examples/03-lanes-regions.hvis)

## State Machine

```yaml
OrderState[state-machine]:
  - initial --> Created
  - Created[state]
  - Paid[state]:
      entry_action: "sendReceipt"
      do_activity: "waitForFulfillment"
      exit_action: "closeInvoice"
      internal_transitions:
        - trigger: "refundRequested"
          action: "openRefundCase"
      deferred:
        - "shipmentUpdated"
  - Created --> Paid:
      trigger: "paymentCaptured"
      guard: "amount > 0"
      action: "recordPayment"
  - Paid --> final:
      trigger: "shipped"
```

Purpose: UML-style state machines.

Node types: `state`, `composite-state`, `region`, and pseudostates such as
initial, final, choice, junction, fork, join, entry-point, exit-point,
terminate, and history (`type: shallow` or `deep`). `initial` and `final` can be
used as implicit endpoint names.

Transitions take `trigger`, `guard`, `action`, and `completion`. States take
`entry_action`, `do_activity`, `exit_action`, `internal_transitions`, and
`deferred`. Composite states nest states in a list body, or use `regions:` for
orthogonal regions (see [grammar.md](./grammar.md#state-machine-regions)).

Validation checks vocabulary, transition endpoints and properties,
composite/region structure, history kinds, and scoped names.

Examples:

- [01-basic-lifecycle.hvis](../../hypervis-state-machine/references/examples/01-basic-lifecycle.hvis)
- [02-pseudostates-composite.hvis](../../hypervis-state-machine/references/examples/02-pseudostates-composite.hvis)
- [03-regions-internal-transitions.hvis](../../hypervis-state-machine/references/examples/03-regions-internal-transitions.hvis)

## Class

```yaml
Domain[class]:
  - Customer[class]:
      - "+name: String"
      - "+orders: Order[]"
  - Order[class]:
      members:
        - "-id: String"
        - "+payment: PaymentPort"
        - "+total(): Number"
  - PaymentPort[interface]:
      - "+authorize(amount: Number): Boolean"
  - Customer --> Order:
      type: association
      source_role: "buyer"
      target_role: "orders"
      source_multiplicity: "1"
      target_multiplicity: "0..*"
  - Order --> PaymentPort:
      type: dependency
```

Purpose: UML class diagrams and scanner-generated code structure.

Node types: `class`, `interface`, `enum`, `datatype`, and `package` (a
container whose list body holds class-like nodes). Members go under `members:`
or directly as a list of strings.

Relationship `type` must be one of `association`, `dependency`, `inherits`,
`implements`, `composition`, or `aggregation`. Associations take
`source_role`, `target_role`, `source_multiplicity`, `target_multiplicity`,
`navigability`, `association_class`, and `constraint`. Class properties include
`abstract`, `stereotypes`, and `template_parameters`.

Validation checks member syntax, identifiers, relationship semantics,
multiplicity, roles, inheritance/implementation misuse, and member-type
evidence for relationships.

Examples:

- [01-members-interfaces-enums.hvis](../../hypervis-class/references/examples/01-members-interfaces-enums.hvis)
- [02-relationships-multiplicity.hvis](../../hypervis-class/references/examples/02-relationships-multiplicity.hvis)
- [03-stereotypes-templates-association.hvis](../../hypervis-class/references/examples/03-stereotypes-templates-association.hvis)

## C4 Context

```yaml
Platform[c4-context]:
  - Customer[person]: "Places orders"
  - Platform[software-system, scope]: "Retail checkout platform"
  - Payments[external-software-system]: "Card payment provider"
  - Customer --> Platform: "Places orders"
  - Platform --> Payments:
      label: "Authorizes payments"
      type: calls
```

Purpose: one software system in context with people and external systems.

Node types: `person`, `system`, `software-system`, `external-software-system`,
and the boundaries `boundary`, `system-boundary`, `enterprise-boundary`. Mark
the system in scope with the `scope` annotation or `scope: true`.

Relationship types: `uses`, `depends-on`, `calls`, `reads-from`, `writes-to`,
`sends-to`, `publishes-to`, `subscribes-to`.

Validation rejects lower-level elements such as containers, components,
classes, and databases, and checks descriptions, labels, scope, reachability,
and boundary contents.

Examples:

- [01-saas-context.hvis](../../hypervis-c4-context/references/examples/01-saas-context.hvis)
- [02-boundaries-and-metadata.hvis](../../hypervis-c4-context/references/examples/02-boundaries-and-metadata.hvis)

## C4 Container

```yaml
Checkout[c4-container]:
  - Shopper[person]: "Completes checkout"
  - Checkout[software-system, scope]: "Retail checkout platform"
  - CheckoutBoundary[system-boundary]:
      - label: "Checkout"
      - WebApp[container]:
          description: "Customer UI"
          technology: "React"
      - API[container]:
          description: "Backend API"
          technology: "Rust"
  - Shopper --> WebApp: "Uses checkout pages"
  - WebApp --> API:
      label: "Submits orders"
      protocol: "HTTPS"
```

Purpose: containers inside one software system, plus the people and external
systems that interact with them.

Primary node types: `container`, `database`, `data-store`. Supporting types:
`person`, `system`, `software-system`, `external-software-system`. Boundaries:
`boundary`, `system-boundary`, `enterprise-boundary`.

Only a software system may carry `scope`; put the containers inside a
`system-boundary`. Container-to-container relationships should declare
`protocol`, `technology`, or `transport`, and labels should be specific
(validation flags generic labels such as "Calls").

Examples:

- [01-system-containers.hvis](../../hypervis-c4-container/references/examples/01-system-containers.hvis)
- [02-boundary-and-technology.hvis](../../hypervis-c4-container/references/examples/02-boundary-and-technology.hvis)

## C4 Component

```yaml
PaymentAPI[c4-component]:
  - API[container, scope]: "Payment API"
  - APIBoundary[container-boundary]:
      - PaymentController[component]:
          description: "Handles payment requests"
          technology: "Axum"
      - PaymentService[component]:
          description: "Coordinates payment workflow"
          technology: "Rust"
  - PaymentController --> PaymentService:
      label: "Delegates command"
      protocol: "in-process"
```

Purpose: components inside one container plus neighboring containers,
systems, people, and stores.

Primary node type: `component`. Supporting types: `person`, `system`,
`software-system`, `external-software-system`, `container`, `database`,
`data-store`. Boundaries: `boundary`, `container-boundary`.

Components belong inside the container boundary; supporting elements usually
sit outside it. Relationships to containers or systems should declare
`protocol`, `technology`, or `transport`.

Examples:

- [01-service-components.hvis](../../hypervis-c4-component/references/examples/01-service-components.hvis)
- [02-container-boundary.hvis](../../hypervis-c4-component/references/examples/02-container-boundary.hvis)

## C4 Code

```yaml
PaymentModule[c4-code]:
  - PaymentComponent[component, scope]: "Scoped component"
  - PaymentPackage[package]:
      - PaymentService[class]:
          members:
            - "+authorize(command: AuthorizePayment): Result"
      - PaymentPort[interface]:
          members:
            - "+authorize(request: PaymentRequest): PaymentResult"
  - PaymentService --> PaymentPort:
      type: implements
      label: "implements"
```

Purpose: code-level structure inside one component.

Primary node types: `class`, `interface`, `enum`, `trait`, `struct`, `object`,
`function`, `module`, `record`, `database-table`. Supporting types:
`component`, `container`, `database`, `data-store`. Boundaries: `boundary`,
`component-boundary`, `package`.

Relationship types include the C4 relationships plus `inherits`,
`implements`, `composition`, `aggregation`, `association`, and `dependency`.
Structural relationships are type-checked; for example, `implements` must
target an interface or trait.

Examples:

- [01-modules-functions-tables.hvis](../../hypervis-c4-code/references/examples/01-modules-functions-tables.hvis)
- [02-members-and-boundaries.hvis](../../hypervis-c4-code/references/examples/02-members-and-boundaries.hvis)

## Threat Model

```yaml
UploadThreatModel[threat-model]:
  - User[external-entity]: "Uploads content"
  - Internet[trust-boundary]:
      - UploadAPI[process]:
          description: "Accepts upload requests"
          technology: "Rust"
      - FileStore[data-store]:
          description: "Stores uploaded files"
          encrypted: true
  - User --> UploadAPI:
      label: "HTTPS upload"
      encrypted: true
      data_classification: pii
      flow_id: F1
  - UploadAPI --> FileStore:
      label: "Write object"
      encrypted: true
  - threats:
      - element: UploadAPI
        category: spoofing
        severity: high
        status: mitigated
        mitigation: "OIDC token validation"
```

Purpose: STRIDE-compatible data-flow diagrams with trust boundaries and
authored threats.

Node types: `trust-boundary` (a container), `process`, `data-store`,
`external-entity`. Edges are `data-flow`s and must be directional: model
two-way traffic as two flows (`<-->` and `bidirectional: true` are rejected).

Edge properties: `label`, `encrypted`, `authenticated`, `protocol`, `data`,
`data_classification`, `flow_id`, and `threats`. Nodes can also carry
`threats`, `mitigations`, and `controls`.

Threats can sit on a node or edge, or in a diagram-level `- threats:` list that
targets an `element`, `flow_id`, or `from`/`to` pair. Each threat has a
`category` (`spoofing`, `tampering`, `repudiation`, `information-disclosure`,
`denial-of-service`, `elevation-of-privilege`), `severity`, `status`, and
`mitigation` or `description`.

Validation checks threat vocabulary, severity/status, endpoints, flow IDs,
boundary crossings, sensitive classifications, encryption, and threat targets.

Examples:

- [01-boundaries-and-data-flows.hvis](../../hypervis-threat-model/references/examples/01-boundaries-and-data-flows.hvis)
- [02-nested-boundaries-and-controls.hvis](../../hypervis-threat-model/references/examples/02-nested-boundaries-and-controls.hvis)
- [03-auth-webhook-and-queue.hvis](../../hypervis-threat-model/references/examples/03-auth-webhook-and-queue.hvis)

## Gantt

```yaml
LaunchPlan[gantt]:
  - timeline:
      scale: week
      today: 2026-06-10
      timezone: Europe/Sofia
  - calendar:
      work_week: [mon, tue, wed, thu, fri]
      holidays:
        - 2026-06-24
  - Design[task]:
      start: 2026-06-10
      duration: 5d
      resource: Alice
      progress: 50%
  - Build[task]:
      start: 2026-06-17
      end: 2026-06-30
      depends_on:
        - task: Design
          type: finish-start
          lag: 2d
  - Launch[milestone]:
      date: 2026-07-01
      depends_on:
        - Build
```

Purpose: project plans, resource lanes, milestones, dependencies, and
timelines.

Node types: `task`, `milestone`, `group`, `lane`, `resource` (aliases such as
`phase` and `section` normalize to group). Groups and lanes hold tasks in a
list body.

Gantt has no arrow edges. Declare dependencies on the dependent task with
`depends_on:`, as a list of task names or of mappings with `task`, `type`
(`finish-start`, `start-start`, `finish-finish`, `start-finish`, `soft-link`;
`fs`/`ss`/`ff`/`sf` also work), and `lag` or `lead`.

Task properties: `start`, `end`, `duration`, `progress`, `resource`, `lane`,
`status`, `baseline_start`, `baseline_end`, `actual_start`, `actual_end`,
`deadline`, `critical`, `priority`, `tags`. Milestones use `date`.

Diagram directives: `timeline` (`scale`, `start`, `end`, `today`, `timezone`,
`show_weekends`, ...), `calendar` (`work_week`, `holidays`, `excludes`),
`markers`, `critical_path`, `columns`, `sort`, `defaults`, `dependencies`.

Validation checks dates and durations, resources, dependency targets and
cycles, calendar settings, markers, and critical-path options.

Examples:

- [01-basic-tasks.hvis](../../hypervis-gantt/references/examples/01-basic-tasks.hvis)
- [02-groups-milestones-resources.hvis](../../hypervis-gantt/references/examples/02-groups-milestones-resources.hvis)
- [03-calendars-dependencies-critical-path.hvis](../../hypervis-gantt/references/examples/03-calendars-dependencies-critical-path.hvis)

## Deployment

```yaml
KubernetesPlatform[deployment]:
  - PlatformCluster[cluster]:
      - provider: k8s
      - platform: kubernetes
      - AppNamespace[namespace]:
          - WebDeployment[deployment]:
              - image: "registry.example.com/web:2026.06"
              - WebPod[pod]:
                  - WebContainer[container]
          - AppSecret[secret]
  - WebDeployment --> AppSecret:
      type: uses-secret
```

Purpose: infrastructure and runtime topology: clouds, regions, networks,
clusters, namespaces, workloads, data stores, routing, and their relationships.

Nesting uses list bodies at every level. Properties of a container node are
single-key list items before its children (`- provider: k8s`); leaf nodes can
use a plain mapping body.

Node vocabulary:

- scopes: `cloud`, `region`, `zone`, `availability-zone`, `edge-location`
- networking: `network`, `vpc`, `subnet`, `security-group`, `firewall`,
  `private-link`, `vpn`
- compute: `cluster`, `namespace`, `node-pool`, `node`, `function`
- workloads: `workload`, `deployment`, `statefulset`, `daemonset`, `job`,
  `cronjob`, `pod`, `container`
- routing: `service`, `ingress`, `gateway`, `load-balancer`, `api-gateway`,
  `dns`, `cdn`
- config and storage: `config-map`, `secret`, `volume`, `persistent-volume`,
  `persistent-volume-claim`, `bucket`, `object-store`
- data: `database`, `cache`, `queue`, `topic`, `registry`
- other: `identity-provider`, `external-system`

Relationship types:

- placement: `hosts`, `runs`, `deploys-to`, `contains`, `scheduled-on`
- traffic: `routes-to`, `calls`, `connects-to`, `exposes`, `forwards-to`
- data: `reads-from`, `writes-to`, `publishes-to`, `subscribes-to`
- mounts and config: `mounts`, `uses-secret`, `uses-config`, `pulls-image-from`
- security: `allows`, `denies`, `terminates-tls`, `authenticates-with`

Node properties: `provider` (`aws`, `azure`, `gcp`, `k8s`, `generic`),
`platform` (`kubernetes`, `vm`, `serverless`, `managed`), `environment`,
`region`, `zone`, `replicas`, `image`, `version`, `public`, `encrypted`,
`managed`. Edge properties: `type`, `protocol`, `port`, `encrypted`,
`internal`, and `direction` (`ingress`/`egress`).

Validation checks vocabulary, endpoints, namespace nesting for Kubernetes
workloads (a `container` must sit inside a pod or workload), cluster placement,
workload `image`/`version`, database encryption, and provider-specific
properties.

Examples:

- [01-kubernetes-platform.hvis](../../hypervis-deployment/references/examples/01-kubernetes-platform.hvis)
- [02-cloud-neutral-provider.hvis](../../hypervis-deployment/references/examples/02-cloud-neutral-provider.hvis)
- [03-node-types-and-relationships.hvis](../../hypervis-deployment/references/examples/03-node-types-and-relationships.hvis)
