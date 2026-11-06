# HyperVisual Class Layout and Rendering

## Layout Behavior

- Renders class boxes with compartments.
- Uses target-aware layout direction, spacing, compact packing, and candidate scoring when eligible.

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
