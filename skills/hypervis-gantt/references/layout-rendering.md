# HyperVisual Gantt Layout and Rendering

## Layout Behavior

- Renders a Gantt-specific table and timeline payload rather than generic node boxes.

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
- Prefer `timeline.scale` and related Gantt settings for time axis behavior; flowchart-style `layout.direction` does not apply here.
