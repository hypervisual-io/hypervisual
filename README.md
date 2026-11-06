# HyperVisual

Architecture diagrams that validate themselves. You write typed YAML (`.hvis` files); the `hypervis` CLI parses, validates, renders (SVG/PNG), diffs and scans them, and exposes the same tools to AI agents over MCP.

Early preview: `.hvis` replaces the old `.codi` extension, which keeps working. In v0.1.0 the CLI's help text and `hypervis test` on a folder (which only picks up `.codi`) still use the old name.

## Install the CLI

With a package manager, which also handles updates:

```bash
npx hypervis help            # no install
pipx install hypervis
cargo install hypervis
```

Or with the install script attached to a release (v0.2.0 and later), which does not update an existing install (re-run it for a newer release):

```bash
curl -fsSL https://github.com/hypervisual-io/hypervisual/releases/download/v0.2.0/install.sh | HYPERVISUAL_VERSION=v0.2.0 sh
```

Prebuilt for macOS arm64 and Linux x86_64/arm64 (glibc 2.28+). The script installs `hypervis` and the short alias `hvis` to `~/.local/bin`; set `HYPERVISUAL_INSTALL_DIR` to change the location. Binaries are also attached to each [release](https://github.com/hypervisual-io/hypervisual/releases).

### Verify a download

From v0.2.0, each release archive and `install.sh` carries a GitHub build attestation from the [release workflow](.github/workflows/release.yml), and `SHA256SUMS` lists their checksums:

```bash
gh attestation verify hypervis-x86_64-unknown-linux-gnu.tar.gz --repo hypervisual-io/hypervisual
sha256sum -c SHA256SUMS --ignore-missing   # macOS: shasum -a 256 -c SHA256SUMS --ignore-missing
```

To have the script check the attestation as well, set `HYPERVISUAL_VERIFY_ATTESTATION=1` (requires `gh`).

Validation runs the built-in diagram rules in Python, so `python3` 3.9+ must be on `PATH` (or set `CODI_PYTHON_PATH`).

```bash
hypervis validate diagram.hvis
hypervis render diagram.hvis --format svg -o diagram.svg
hypervis help
```

## Install the agent skills

```bash
npx skills add hypervisual-io/hypervisual
```

This installs `hypervis-cli` (shared workflow and grammar) plus one skill per diagram type (C4, sequence, class, activity, state machine, threat model, deployment, flowchart, gantt, unstructured). You can also copy the folders under [`skills/`](skills) into your agent's skills directory.

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
