#!/usr/bin/env bash
set -euo pipefail

file="${1:?usage: hypervis-validate-render.sh <file.hvis> [output.svg]}"
output="${2:-${file%.*}.svg}"

bin=""
for candidate in hypervis hvis codi; do
  if command -v "$candidate" >/dev/null 2>&1; then
    bin="$candidate"
    break
  fi
done
if [ -z "$bin" ]; then
  echo "hypervis CLI not found; run scripts/hypervis-doctor.sh" >&2
  exit 127
fi

"$bin" validate "$file"
"$bin" render "$file" --format svg -o "$output"
echo "$output"
