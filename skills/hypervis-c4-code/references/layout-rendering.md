# HyperVisual C4 Code Layout and Rendering

## Layout Behavior

- Uses class/code element layout with target-aware compact packing.

## Render Commands

```bash
hypervis render diagram.hvis --format svg -o diagram.svg
hypervis render diagram.hvis --theme dark --format svg -o diagram-dark.svg
hypervis render diagram.hvis --ratio 16:9 --width 1280 --format svg -o diagram-wide.svg
```

## Guidance

- Prefer SVG for documentation and review.
- Use PNG only when explicitly requested or required.
- Use `--ratio`, `--width`, `--height`, or `--size` as CLI flags; do not put render targets in `.hvis` source.
- When you need a preferred graph direction in source, set it under a diagram-level `layout:` block (for example `layout:\n  direction: LR`).
