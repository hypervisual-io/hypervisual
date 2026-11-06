#!/usr/bin/env bash
set -euo pipefail

bin=""
for candidate in hypervis hvis; do
  if command -v "$candidate" >/dev/null 2>&1; then
    bin="$candidate"
    break
  fi
done

if [ -z "$bin" ]; then
  echo "hypervis CLI not found (no hypervis or hvis on PATH or as a shell alias/function)"
  echo "Do not fabricate SVG/PNG/validation output without it."
  echo "Install: curl -fsSL https://github.com/hypervisual-io/hypervisual/releases/download/v0.2.0/install.sh | HYPERVISUAL_VERSION=v0.2.0 sh"
  echo "     or: pipx install hypervis | cargo install hypervis | npx hypervis"
  exit 127
fi

"$bin" --help >/dev/null
echo "hypervis CLI is available as '$bin': $(command -v "$bin")"
if version="$("$bin" --version 2>/dev/null)"; then
  echo "$version"
else
  echo "warning: '$bin --version' failed, so this is v0.1.0 or older; these skills need v0.2.0+, upgrade it"
fi

python="${HVIS_PYTHON_PATH:-python3}"
if ! "$python" -c 'import sys; sys.exit(sys.version_info < (3, 9))' >/dev/null 2>&1; then
  echo "warning: validators need Python 3.9+ as python3 on PATH or via HVIS_PYTHON_PATH ($python not usable)"
fi
