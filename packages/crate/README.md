# hypervisual

Launcher for the HyperVisual CLI (`codi`): architecture diagrams as code that validate themselves.

```sh
cargo install hypervisual
hypervisual validate architecture.codi
```

On first run it downloads the matching `codi` binary from [GitHub Releases](https://github.com/hypervisual-io/hypervisual/releases) with `curl`, verifies its SHA-256 and caches it under `~/.cache/hypervisual`. Set `HYPERVISUAL_VERSION` to pin another release tag.

Supported: macOS arm64, Linux x86_64 and arm64. Validation needs Python 3.9+ as `python3`.

See [hypervisual-io/hypervisual](https://github.com/hypervisual-io/hypervisual) for agent skills and MCP setup.
