#!/bin/sh
# HyperVisual CLI installer: downloads the `codi` binary from GitHub Releases.
#   curl -fsSL https://raw.githubusercontent.com/hypervisual-io/hypervisual/main/install.sh | sh
# Environment:
#   HYPERVISUAL_VERSION      release tag to install (default: latest)
#   HYPERVISUAL_INSTALL_DIR  target directory (default: $HOME/.local/bin)
set -eu

REPO="hypervisual-io/hypervisual"
VERSION="${HYPERVISUAL_VERSION:-latest}"
INSTALL_DIR="${HYPERVISUAL_INSTALL_DIR:-$HOME/.local/bin}"

say() { printf 'hypervisual: %s\n' "$*"; }
die() { printf 'hypervisual: error: %s\n' "$*" >&2; exit 1; }

os="$(uname -s)"
arch="$(uname -m)"
case "$os/$arch" in
  Darwin/arm64) target="aarch64-apple-darwin" ;;
  Linux/x86_64 | Linux/amd64) target="x86_64-unknown-linux-gnu" ;;
  Linux/aarch64 | Linux/arm64) target="aarch64-unknown-linux-gnu" ;;
  *) die "no prebuilt binary for $os/$arch yet (available: macOS arm64, Linux x86_64, Linux arm64)" ;;
esac

asset="codi-$target.tar.gz"
if [ "$VERSION" = "latest" ]; then
  base="https://github.com/$REPO/releases/latest/download"
else
  base="https://github.com/$REPO/releases/download/$VERSION"
fi

fetch() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -q "$1" -O "$2"
  else
    die "curl or wget is required"
  fi
}

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT INT TERM

say "downloading $asset ($VERSION)"
fetch "$base/$asset" "$tmp/$asset" || die "download failed: $base/$asset"
fetch "$base/$asset.sha256" "$tmp/$asset.sha256" || die "checksum download failed"

expected="$(cut -d' ' -f1 < "$tmp/$asset.sha256")"
if command -v sha256sum >/dev/null 2>&1; then
  actual="$(sha256sum "$tmp/$asset" | cut -d' ' -f1)"
elif command -v shasum >/dev/null 2>&1; then
  actual="$(shasum -a 256 "$tmp/$asset" | cut -d' ' -f1)"
else
  die "sha256sum or shasum is required to verify the download"
fi
[ "$expected" = "$actual" ] || die "checksum mismatch for $asset"

tar -xzf "$tmp/$asset" -C "$tmp"
mkdir -p "$INSTALL_DIR"
install -m 755 "$tmp/codi" "$INSTALL_DIR/codi" 2>/dev/null || { cp "$tmp/codi" "$INSTALL_DIR/codi"; chmod 755 "$INSTALL_DIR/codi"; }
say "installed $INSTALL_DIR/codi"

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *) say "note: $INSTALL_DIR is not on PATH; add it, e.g. export PATH=\"$INSTALL_DIR:\$PATH\"" ;;
esac

py="${CODI_PYTHON_PATH:-python3}"
if ! "$py" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)' >/dev/null 2>&1; then
  say "note: validation needs Python 3.9+ as python3 (or set CODI_PYTHON_PATH)"
fi
