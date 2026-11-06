# HyperVisual

Architecture diagrams that validate themselves. You write typed YAML (`.codi` files); the `hypervis` CLI parses, validates, renders (SVG/PNG), diffs and scans them, and exposes the same tools to AI agents over MCP.

Early preview: the file extension is being renamed from `.codi` to `.hvis`, and the CLI's own help text still says `codi`.

## Install the CLI

With a package manager, which also handles updates:

```bash
npx hypervis help            # no install
pipx install hypervis
cargo install hypervis
```

Or with the install script, which does not update an existing install (re-run it for a newer release):

```bash
curl -fsSL https://raw.githubusercontent.com/hypervisual-io/hypervisual/main/install.sh | sh
```

Prebuilt for macOS arm64 and Linux x86_64/arm64 (glibc 2.28+). The script installs `hypervis` to `~/.local/bin`; set `HYPERVISUAL_INSTALL_DIR` or `HYPERVISUAL_VERSION` to change the location or pin a release. Binaries are also attached to each [release](https://github.com/hypervisual-io/hypervisual/releases).

Validation runs the built-in diagram rules in Python, so `python3` 3.9+ must be on `PATH` (or set `CODI_PYTHON_PATH`).

```bash
hypervis validate diagram.codi
hypervis render diagram.codi --format svg -o diagram.svg
hypervis help
```

## Install the agent skills

```bash
npx skills add hypervisual-io/hypervisual
```

This installs `codi-cli` (shared workflow and grammar) plus one skill per diagram type (C4, sequence, class, activity, state machine, threat model, deployment, flowchart, gantt, unstructured). You can also copy the folders under [`skills/`](skills) into your agent's skills directory.

## Use it over MCP

The `mcp` subcommand runs an MCP server over stdio with `codi_validate`, `codi_render`, `codi_expand`, `codi_diff` and `codi_scan`. The configs below need only Node; if you installed the CLI, you can use `hypervis mcp` instead.

Cursor (`.cursor/mcp.json`) or any client using the same format:

```json
{ "mcpServers": { "hypervisual": { "command": "npx", "args": ["-y", "hypervis", "mcp"] } } }
```

Claude Code:

```bash
claude mcp add hypervisual -- npx -y hypervis mcp
```

## License

Apache-2.0
