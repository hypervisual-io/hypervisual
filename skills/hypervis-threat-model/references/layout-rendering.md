# HyperVisual Threat Model Layout and Rendering

## Layout Behavior

- Uses trust-boundary/data-flow layout and boundary-aware packing.

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
- Use explicit source `direction` when layout direction matters more than target aspect ratio.
