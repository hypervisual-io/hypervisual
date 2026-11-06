---
name: hypervis-cli
description: Shared HyperVisual CLI and .hvis language workflow. Use when working with HyperVisual files, installing HyperVisual diagram skills, checking hypervis availability, using hypervis help, validating, rendering, scanning, expanding, diffing, or troubleshooting .hvis diagrams. Install this with any hypervis-* diagram skill.
---

# HyperVisual CLI

HyperVisual source is YAML: one top-level `Name[type]` key whose value is a
list of nodes, edges, and directives. This shared skill covers the common
grammar, CLI commands, validation loop, and rendering used by every
`hypervis-*` diagram skill. Install it alongside any of them.

## Availability First

Before running any HyperVisual command, confirm the CLI is reachable:

```bash
command -v hypervis    # or: command -v hvis
scripts/hypervis-doctor.sh
```

`command -v` also matches shell aliases and functions, but aliases defined only
in an interactive profile may not load in a non-interactive shell.

If it is missing, install it (no account or token needed):

```bash
curl -fsSL https://raw.githubusercontent.com/hypervisual-io/hypervisual/main/install.sh | sh
# or: pipx install hypervis | cargo install hypervis | npx hypervis <command>
```

The script installs `hypervis` plus the alias `hvis` into `~/.local/bin`
(override with `HYPERVISUAL_INSTALL_DIR`). Validators need Python 3.9+ on
`PATH` as `python3`, or `CODI_PYTHON_PATH` pointing at one.

If the CLI still cannot be run, treat it as unavailable:

- Never hand-write or otherwise fake an SVG, PNG, validation report, diff, or
  expanded output. There is no fallback renderer or validator.
- Refuse the validate/render/scan/diff/expand action and tell the user that
  `hypervis` could not be located and must be on `PATH` or exposed as an alias
  or function.
- You may still author or edit `.hvis` source from the references, but say
  clearly that it was not validated or rendered.

## Command Truth

Prefer the installed CLI's help over memory:

```bash
hypervis help
hypervis help validate
hypervis help render
hypervis help scan
```

v0.1.0 naming quirks: its help text still prints `codi` as the program name and
mentions `.codi` files, and `hypervis test <folder>` only discovers `*.codi`
files. `validate`, `render`, and the other commands accept `.hvis` (any
extension). Diagnostic codes (`CODI-PARSE-001`, ...), the `CODI_DIAG` output
prefix, the `CODI_PYTHON_PATH` variable, and the MCP tool names (`codi_validate`,
`codi_render`, ...) keep the `codi` name.

## Grammar Essentials

- Child nodes go directly in the parent's list body. There is no `children:`
  key.
- Layout (`direction`, `rank_gap`, `node_gap`, `algorithm`, `width`, ...) goes
  under `layout:`; visuals (`fill`, `stroke`, `stroke_width`, `shape`, `line`,
  ...) go under `style:`. Bare keys are parse errors.
- Property names are `snake_case`.
- `gantt` has no arrow edges; tasks declare `depends_on:`.

```yaml
Checkout[flowchart]:
  - layout:
      direction: LR
  - Cart[process]
  - Payment[group]:
      - Authorize[process]:
          style:
            fill: "#eff6ff"
      - Capture[process]
      - Authorize --> Capture
  - Cart --> Authorize: "pay"
```

## Reference Routing

- CLI commands: `references/cli.md`
- Common grammar: `references/grammar.md`
- Per-type vocabulary and examples: `references/diagram-types.md`
- Validation and diagnostics: `references/validation.md`
- Rendering, sizing, themes, and PNG/SVG: `references/rendering-and-scaling.md`

## Validation Loop

1. Write or edit `.hvis` source using a diagram-specific skill.
2. Run `hypervis validate <file>`.
3. Fix `error` and `critical` diagnostics; parse errors name the rule and fix.
4. Render with `hypervis render <file> --format svg -o <file.svg>`, or run
   `scripts/hypervis-validate-render.sh <file.hvis>`.

`render` defaults to PNG, so pass `--format svg` for docs and review. Use PNG
only when requested or required by a target system.
