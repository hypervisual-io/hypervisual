# Validation and Diagnostics

Validation runs after parsing. A file can parse and still fail validation
because its vocabulary, endpoints, properties, or type-specific rules are
wrong.

## Commands

```bash
hypervis validate diagram.hvis
hypervis validate diagram.hvis --strict
hypervis validate diagram.hvis --format json
cat diagram.hvis | hypervis validate - --source-name editor.hvis --format json
```

`hypervis render` validates first and refuses to render on errors.

## Diagnostic Shape

Text output prints one `HVIS_DIAG` line per diagnostic to stderr, for example:

```text
HVIS_DIAG validator=default:class severity=warning code=HVIS-CLS-PY-140 file=domain.hvis line=3 column=5 path=PaymentPort point="PaymentPort" description="interface 'PaymentPort' has no public members"
```

JSON output (`--format json`) is a list of objects with `severity`, `code`,
`message`/`description`, `validator`, `file`, `line`, `column`, `end_line`,
`end_column`, `hint`, `path`, `point`, `node`, `edge`, `member`, and
`doc_url`. `line` and `column` are 1-based; `end_line`/`end_column` (end
exclusive) and `hint` are `null` when unknown.

Severities are `critical`, `error`, `warning`, and `info`. `critical` and
`error` fail validation (exit `1`); `warning` and `info` do not, unless
`--strict` promotes them.

## Parse and Runtime Diagnostics

| Code | Meaning |
|---|---|
| `HVIS-IO-001` | Source file or stdin could not be read |
| `HVIS-PARSE-001` | YAML or grammar error; the description states the rule |
| `HVIS-VALIDATOR-TYPE-001` | No built-in validator for the diagram type and no `--type-path` |
| `HVIS-VALIDATOR-PATH-001` | `--type-path` file could not be loaded |
| `HVIS-VALIDATOR-RUNTIME-001` | Python validator failed at runtime |

Parse errors always carry a location: the YAML error position, or the
offending key or item, falling back to the enclosing node or the diagram
declaration. Parsing stops at the first error. Text output repeats it after
the `HVIS_DIAG` line as a readable block (also on stderr) with the source
excerpt, a caret under the span, and the hint when there is one:

```text
critical[HVIS-PARSE-001]: Failed to parse YAML: found unexpected end of stream at line 4 column 1, while scanning a quoted scalar at line 2 column 20
 --> quote.hvis:3:17
  |
2 |   - Cart[process]: "unclosed
3 |   - Pay[process]
  |                 ^
  = hint: the quoted string opened at line 2, column 20 is never closed; add the closing quote
```

The description names the rule, for example:

- `the 'children:' keyword was removed; nest child nodes directly as list items`
- `diagram-level 'direction' must be nested under the 'layout:' directive`
- `'fill' must be nested under 'style:' as 'fill'`
- `'AppNamespace[namespace]' looks like a nested node or edge; children must be written as list items`
- `gantt does not use arrow edges; declare dependencies with 'depends_on:' on the task`

Validators run in Python: they need Python 3.9+ as `python3` on `PATH`, or
`HVIS_PYTHON_PATH` pointing at an interpreter.

## Render Diagnostics

`hypervis render` reports these after validation passes; `validate` does not.

| Code | Severity | Meaning |
|---|---|---|
| `HVIS-LAYOUT-001` | warning | A group, lane, boundary, or fragment title is wider than groups grow for, so it is truncated; shorten the label |
| `HVIS-RENDER-FONT-001` | error | PNG only: no available font matches the text's font family |
| `HVIS-RENDER-FONT-002` | error | PNG only: no available font has glyphs for some characters (listed) |

On a font error no PNG is written. Render SVG, which keeps the text, or install
a font that covers it. See
[rendering-and-scaling.md](./rendering-and-scaling.md#png-rendering).

## Source Mapping

Validator diagnostics are mapped back to source lines by diagnostic `path`,
node name, edge endpoints, or class member. When no precise location is found,
the diagnostic still names the best available node, edge, path, or point.

## Strict Mode

`--strict` treats C4 and style convention warnings as errors where the
validator supports it, for example generic or missing C4 relationship labels.
It is a validation policy, not a different grammar.

## Custom Diagram Types

```bash
hypervis validate custom.hvis --type-path ./custom_type.py
hypervis render custom.hvis --type-path ./custom_type.py --format svg -o custom.svg
```

For custom types the CLI calls Python hooks for expansion, validation, and
layout. For built-in types, `--type-path` can supply a validation override.

## Common Validation Failures

| Problem | Typical cause | Fix |
|---|---|---|
| Unknown diagram type | Top-level `[type]` is not built in | Use a built-in type or pass `--type-path` |
| Unknown node or edge type | Not in the type's vocabulary | Use the vocabulary in [diagram-types.md](./diagram-types.md) |
| Unknown endpoint | Edge names a node that was not declared | Add the node or fix the spelling |
| Duplicate node name | Same name appears twice in a scope | Rename, or nest where the type supports it |
| Missing scope | C4 diagram has no scoped element | Add the `scope` annotation or `scope: true` |
| Missing or generic label | C4 relationship has no specific label | Add a descriptive scalar label or `label:` |
| Invalid property | Unsupported or misspelled key, often a hyphenated name | Use the `snake_case` name the validator lists |
| Unexpected untyped node | Unrecognized single-key item in a list body | Use a recognized property key or a typed node |

## Validating Documentation Examples

```bash
hypervis validate docs-example.hvis
hypervis render docs-example.hvis --format svg -o docs-example.svg
```

Use `--strict` for examples meant to show best practice; compact examples may
carry documented warnings.
