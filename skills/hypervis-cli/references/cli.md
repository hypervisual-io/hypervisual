# HyperVisual CLI Reference

Confirm the CLI is reachable before any command with `command -v hypervis`
(the install script also provides the short alias `hvis`). If it is missing, do
not fabricate output: there is no fallback renderer or validator. See
`SKILL.md` for install and refusal rules.

v0.1.0 commands: `render`, `validate`, `diff`, `expand`, `test`, `scan`, `mcp`,
and `help`. There is no `--version` flag.

## Help

```bash
hypervis help
hypervis help render
hypervis help validate
hypervis <command> --help
```

When these notes conflict with `hypervis help`, trust the help output. In
v0.1.0 the help text still prints the program name as `codi` and refers to
`.codi` files; run the commands as `hypervis`, and `.hvis` files work
everywhere except `hypervis test <folder>` (see Test).

## Validate

```bash
hypervis validate diagram.hvis
hypervis validate diagram.hvis --strict
hypervis validate diagram.hvis --format json
cat diagram.hvis | hypervis validate - --source-name editor.hvis --format json
```

Validation exits with status `1` when any diagnostic has `error` or `critical`
severity. Text diagnostics (`CODI_DIAG ...` lines) go to stderr; JSON goes to
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
hypervis render custom.hvis --type-path ./custom_type.py --format svg -o custom.svg
```

Without options, `render` writes PNG to `<input>.png`; pass `--format svg -o
<file>.svg` for documentation. Render validates first and fails on errors. See
[rendering-and-scaling.md](./rendering-and-scaling.md) for sizing rules.

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
hypervis expand diagram.hvis --format codi
hypervis expand custom.hvis --type-path ./custom_type.py --pretty
```

The default is JSON; `--format codi` prints canonical YAML source. Expand
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

In v0.1.0, pointing `test` at a folder only discovers `*.codi` files. Pass
`.hvis` files individually. The runner is partial: snapshot tests render SVG
and compare or update snapshots; some documented test forms are skipped.

## MCP

`hypervis mcp` serves the same operations over stdio for AI agents, as the tools
`codi_validate`, `codi_render`, `codi_expand`, `codi_diff`, and `codi_scan`.
