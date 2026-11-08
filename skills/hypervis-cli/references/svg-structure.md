# SVG Structure

Every drawn node and edge is a `<g>` with a stable id, classes, and
`data-hvis-*` attributes so agents can target elements without matching label
text. Overlays add `hvis-overlay` / `hvis-dimmed` classes; see
[overlays.md](./overlays.md).

```xml
<g id="node-Api" class="hvis-node hvis-type-container"
   data-hvis-name="Api" data-hvis-type="container"
   data-hvis-shape="rounded-rect" data-hvis-parent="ShopBoundary">
  <rect … /><text …>Api</text>
</g>
<g id="edge-WebApp--Api" class="hvis-edge hvis-edge-default"
   data-hvis-from="WebApp" data-hvis-to="Api" data-hvis-kind="default">
  <path … />
</g>
```

## Ids

- Nodes: `node-<Name>`; edges: `edge-<From>--<To>`; threat-model flows with
  `flow_id`: `edge-<flow_id>`. Qualified state names use the full name
  (`node-Billing.Idle`).
- Simple ASCII names (letters, digits, `_`, single inner `-`) are used as-is;
  other names gain a sanitized prefix plus a 6-hex hash of the full UTF-8 name.
  Parallel edges and duplicate names get `--2`, `--3`, … in document order.
- `--svg-id-prefix <PREFIX>` (MCP `svg_id_prefix`, WASM `svgIdPrefix`) prefixes
  every id and `url(#…)` reference for multiple diagrams on one HTML page.

```bash
hypervis render diagram.hvis --svg-id-prefix d1- -o d1.svg
```

## Classes and attributes

| Element | Classes | Attributes |
|---|---|---|
| Node | `hvis-node`, `hvis-type-<type>`; `hvis-group` for boundaries and containers with children | `data-hvis-name`, `data-hvis-type`, `data-hvis-shape`, `data-hvis-parent` |
| Edge | `hvis-edge`, `hvis-edge-<kind>` | `data-hvis-from`, `data-hvis-to`, `data-hvis-kind`, optional `data-hvis-flow-id` |
| Overlay | `hvis-overlay`, `hvis-overlay-<Name>` on path elements; `hvis-dimmed` off path | `data-hvis-overlay` |

Nodes are paint-order siblings; containment is `data-hvis-parent`, not nested
`<g>` elements.

## CSS (inlined SVG)

PNG ignores CSS. For inlined SVG, these are safe to override: `fill`, `stroke`,
`stroke-width`, `stroke-dasharray`, `opacity` on shapes and edge paths; `fill` on
`text`; `opacity`, `visibility`, `display`, `filter`, `cursor`,
`pointer-events` on groups.

Not safe: geometry (`x`, `y`, `width`, `height`, `d`, `points`), `transform` on
nodes or edges, and text metrics (`font-size`, `font-family`, …). Ids, classes,
and `data-hvis-*` are the stable contract; inner structure may change between
versions.
