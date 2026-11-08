# Use HyperVisual in CI

Two GitHub Actions workflows you can copy into `.github/workflows/`. Both run on pull requests that touch a `.hvis` file, need only `contents: read`, and install the CLI with `npm install -g hypervis@0.2.2`, which downloads the release binary and checks its SHA-256. Ubuntu runners already have the `python3` that validation needs.

## Show the diagram diff on every pull request

[`examples/github-actions/hypervis-diff.yml`](../examples/github-actions/hypervis-diff.yml) compares each added or modified `.hvis` file with its version on the base branch (`hypervis diff base.hvis new.hvis`). The run page summary has one section per diagram, for example under `docs/architecture.hvis`:

```text
  nodes: 6 → 6
  edges: 4 → 5

  + edge 'WebApp' → 'Db': "Loads cart (faster!)"

  1 edge added
```

The visual diffs (added green, removed red, changed amber) are uploaded as SVGs in the `hvis-diff` artifact, one per diagram at the same path plus `.svg`. Diagrams that are new in the pull request are rendered as they are. Deleted diagrams are skipped.

The job fails only if a diagram cannot be diffed or rendered, for example because it does not parse. A diagram that changed does not fail it, even though `hypervis diff` exits `1` when it finds changes.

## Fail on invalid diagrams or broken rules

[`examples/github-actions/hypervis-check.yml`](../examples/github-actions/hypervis-check.yml) validates every `.hvis` file in the repository and checks an architecture rule with `query --expect none`, which exits `1` when the pattern matches:

```bash
hypervis query docs/architecture.hvis 'WebApp -> [database]' --expect none
```

Add one `query` step per rule. Use `--expect any` for a path that must exist, and `validate --strict` to fail on convention warnings too. A bad pattern or file exits `2`.

## Limitations

- The diff images are artifacts, not inline in the pull request. Posting them as a comment needs `pull-requests: write` and somewhere to host the image.
- `diff --render` writes SVG only.
