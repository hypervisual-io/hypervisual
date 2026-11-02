# @hypervisual-io/cli

Launcher for the HyperVisual CLI (`codi`): architecture diagrams as code that validate themselves.

```sh
npx @hypervisual-io/cli validate architecture.codi
npx @hypervisual-io/cli render architecture.codi -o architecture.svg
```

On first run it downloads the matching `codi` binary from [GitHub Releases](https://github.com/hypervisual-io/hypervisual/releases), verifies its SHA-256 and caches it under `~/.cache/hypervisual`. Set `HYPERVISUAL_VERSION` to pin another release tag.

Supported: macOS arm64, Linux x64 and arm64. Validation needs Python 3.9+ as `python3`.

See [hypervisual-io/hypervisual](https://github.com/hypervisual-io/hypervisual) for agent skills and MCP setup.
