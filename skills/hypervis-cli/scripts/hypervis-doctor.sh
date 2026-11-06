#!/usr/bin/env bash
set -euo pipefail

bin=""
for candidate in hypervis hvis codi; do
  if command -v "$candidate" >/dev/null 2>&1; then
    bin="$candidate"
    break
  fi
done

if [ -z "$bin" ]; then
  echo "hypervis CLI not found (no hypervis, hvis, or codi on PATH or as a shell alias/function)"
  echo "Do not fabricate SVG/PNG/validation output without it."
  echo "Install: curl -fsSL https://raw.githubusercontent.com/hypervisual-io/hypervisual/main/install.sh | sh"
  echo "     or: pipx install hypervis | cargo install hypervis | npx hypervis"
  exit 127
fi

"$bin" --help >/dev/null
echo "hypervis CLI is available as '$bin': $(command -v "$bin")"

python="${CODI_PYTHON_PATH:-python3}"
if ! "$python" -c 'import sys; sys.exit(sys.version_info < (3, 9))' >/dev/null 2>&1; then
  echo "warning: validators need Python 3.9+ as python3 on PATH or via CODI_PYTHON_PATH ($python not usable)"
fi
