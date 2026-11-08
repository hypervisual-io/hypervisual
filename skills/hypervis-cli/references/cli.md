# HyperVisual CLI Reference

Confirm the CLI is reachable before any command with `command -v hypervis`
(the install script also provides the short alias `hvis`). If it is missing, do
not fabricate output: there is no fallback renderer or validator. See
`SKILL.md` for install and refusal rules.

Commands: `render`, `validate`, `diff`, `expand`, `test`, `scan`, `mcp`,
`version`, and `help`.

## Version

```bash
hypervis --version        # hypervis 0.2.1 (…, aarch64-apple-darwin)
hypervis version --json   # name, version, commit, commit_date, dirty, target
```

Use it to confirm the install before relying on these notes (they describe
v0.2.1) and to record which CLI produced a render or validation result. v0.1.0
has neither form.

## Help

```bash
hypervis help
hypervis help render
hypervis help validate
hypervis <command> --help
```

When these notes conflict with `hypervis help`, trust the help output.

## Validate

```bash
hypervis validate diagram.hvis
hypervis validate diagram.hvis --strict
hypervis validate diagram.hvis --format json
cat diagram.hvis | hypervis validate - --source-name editor.hvis --format json
```

Validation exits with status `1` when any diagnostic has `error` or `critical`
severity. Text diagnostics (`HVIS_DIAG ...` lines) go to stderr; JSON goes to
stdout. Only `validate` reads stdin (`-`); the other commands need a file path.

`--type-path <file.py>` loads a custom diagram type or a validation override.

## Render

```bash
hypervis render diagram.hvis --format svg -o diagram.svg
hypervis render diagram.hvis --format png --raster-scale 2 -o diagram.png
hypervis render diagram.hvis --theme dark --detail overview --format svg -o overview.svg
hypervis render diagram.hvis --size 1600x900 --format svg -o exact.svg
hypervis render diagram.hvis --ratio 16:9 --width 1280 --format svg -o wide.svg
hypervis render diagram.hvis --node PaymentService --format svg -o payment-service.svg
hypervis render diagram.hvis --overlay PaymentPath -o payment-path.png
hypervis render diagram.hvis --no-overlay -o plain.svg
hypervis render diagram.hvis --svg-id-prefix d1- -o d1.svg
hypervis render custom.hvis --type-path ./custom_type.py --format svg -o custom.svg
```

The format is `--format` if given, else PNG when `-o` ends in `.png`, else SVG.
Unknown `--format` values are rejected on `render` and `expand`.
Without `-o` the output is `<input>.svg` (or `<input>.png`). Render validates
first and fails on errors. It also prints render-only warnings such as
`HVIS-LAYOUT-001` (a group title too wide to fit, so it is truncated), and a
PNG whose text cannot be drawn fails with `HVIS-RENDER-FONT-*` errors and no
file. See [rendering-and-scaling.md](./rendering-and-scaling.md) for sizing
and fonts. Overlays: [overlays.md](./overlays.md). Stable SVG ids:
[svg-structure.md](./svg-structure.md).

## Scan

Scan a source directory or GitHub repository into a `class` diagram with
inferred relationships:

```bash
hypervis scan ./src
hypervis scan ./src --name MyProject -o classes.hvis
hypervis scan https://github.com/org/repo --source-kind github -o repo.hvis
hypervis scan ./src -o classes.hvis --render-svg classes.svg
hypervis scan ./src --render-png classes.png --ratio 16:9 --width 1600
```

Output goes to stdout unless `-o` is given. The diagram is named
`Dependencies` unless `--name` is set.

Options:

- `--source-kind auto|local|github` (default `auto`)
- `--relationship-inference strict|conservative|rich` (default `conservative`)
- `--external-type-resolution off|imports|installed` (default `installed`)
- `--include-generated`, `--include-member-metadata`,
  `--include-relationship-evidence`
- `--max-members-per-class <n>` (1024), `--max-relationships-per-class <n>`
  (512), `--max-total-relationships <n>` (10000)
- rendering: `--theme`, `--size`, `--ratio`, `--width`, `--height`,
  `--raster-scale`, `--max-raster-dimension`

## Expand

Print the canonical form:

```bash
hypervis expand diagram.hvis
hypervis expand diagram.hvis --pretty
hypervis expand diagram.hvis --format hvis
hypervis expand custom.hvis --type-path ./custom_type.py --pretty
```

The default is JSON; `--format hvis` prints canonical YAML source. Expand
fails when expansion diagnostics include errors.

## Diff

```bash
hypervis diff old.hvis new.hvis
hypervis diff old.hvis new.hvis --format json
hypervis diff old.hvis new.hvis --render diff.svg --theme dark
hypervis diff old.hvis new.hvis --type-path ./custom_type.py
```

`diff` exits `1` when changes are found and `0` when there are none.

## Test

Run `test:` blocks embedded in diagram files:

```bash
hypervis test diagram.hvis
hypervis test diagrams/ --test render
hypervis test diagrams/ --update-snapshots
```

Pointing `test` at a folder runs every `*.hvis` file under it. The runner is
partial: snapshot tests render SVG and compare or update snapshots; some
documented test forms are skipped.

## MCP

`hypervis mcp` serves the same operations over stdio for AI agents as the MCP
server `hvis`, with the tools `hvis_validate`, `hvis_render`, `hvis_expand`,
`hvis_diff`, and `hvis_scan`. They take diagram text rather than a file path
(`source`, or `old_source`/`new_source` for diff); `hvis_scan` takes an
absolute directory path or GitHub URL as `source`.

`hvis_render` accepts `overlays` (list of overlay names), `no_overlay: true`,
and `svg_id_prefix`, matching CLI `--overlay`, `--no-overlay`, and
`--svg-id-prefix`.
