# hypervis

Launcher for the HyperVisual CLI (`hypervis`): architecture diagrams as code that validate themselves.

```sh
npx hypervis validate architecture.hvis
npx hypervis render architecture.hvis -o architecture.svg
```

On first run it downloads the matching `hypervis` binary from [GitHub Releases](https://github.com/hypervisual-io/hypervisual/releases), verifies its SHA-256 and caches it under `~/.cache/hypervisual`. Set `HYPERVISUAL_VERSION` to pin another release tag.

Supported: macOS arm64, Linux x64 and arm64. Validation needs Python 3.9+ as `python3`.

See [hypervisual-io/hypervisual](https://github.com/hypervisual-io/hypervisual) for agent skills and MCP setup.
