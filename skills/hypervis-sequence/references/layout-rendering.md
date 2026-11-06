# HyperVisual Sequence Layout and Rendering

## Layout Behavior

- Lifelines are laid out horizontally in declaration order.
- Messages, fragments, notes, activation, and destruction events are laid out vertically in source order.
- Render target aspect ratio pads the output but does not change event order.

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
- Sequence layout is driven by lifeline order and message order, not a diagram-level `layout.direction` block.
