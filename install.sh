#!/bin/sh
# HyperVisual CLI installer: downloads the release binary from GitHub Releases
# and installs it as `hypervis`, with `hvis` as a short alias. It does not
# update an existing install.
#   curl -fsSL https://github.com/hypervisual-io/hypervisual/releases/download/v0.2.1/install.sh | HYPERVISUAL_VERSION=v0.2.1 sh
# Environment:
#   HYPERVISUAL_VERSION      release tag to install (default: latest)
#   HYPERVISUAL_INSTALL_DIR  target directory (default: $HOME/.local/bin)
#   HYPERVISUAL_VERIFY_ATTESTATION=1  also verify the archive's build attestation
#                            with `gh attestation verify` (needs gh, logged in; v0.2.0+)
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

# Releases up to v0.1.0 ship `codi-<target>.tar.gz`; later ones `hypervis-<target>.tar.gz`.
asset=""
for name in "hypervis-$target.tar.gz" "codi-$target.tar.gz"; do
  if fetch "$base/$name" "$tmp/$name" 2>/dev/null; then asset="$name"; break; fi
done
[ -n "$asset" ] || die "download failed: no hypervis or codi archive for $target in release $VERSION"
say "downloaded $asset ($VERSION)"
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

if [ "${HYPERVISUAL_VERIFY_ATTESTATION:-}" = 1 ]; then
  command -v gh >/dev/null 2>&1 || die "HYPERVISUAL_VERIFY_ATTESTATION=1 needs the GitHub CLI (gh)"
  gh attestation verify "$tmp/$asset" --repo "$REPO" >/dev/null \
    || die "attestation verification failed for $asset (releases before v0.2.0 have none)"
  say "verified build attestation for $asset"
fi

mkdir "$tmp/x"
tar -xzf "$tmp/$asset" -C "$tmp/x"
if [ -f "$tmp/x/hypervis" ]; then bin="$tmp/x/hypervis"; else bin="$tmp/x/codi"; fi
[ -f "$bin" ] || die "archive $asset contains neither hypervis nor codi"
mkdir -p "$INSTALL_DIR"
install -m 755 "$bin" "$INSTALL_DIR/hypervis" 2>/dev/null || { cp "$bin" "$INSTALL_DIR/hypervis"; chmod 755 "$INSTALL_DIR/hypervis"; }
ln -sf hypervis "$INSTALL_DIR/hvis"
say "installed $INSTALL_DIR/hypervis (also available as hvis)"

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *) say "note: $INSTALL_DIR is not on PATH; add it, e.g. export PATH=\"$INSTALL_DIR:\$PATH\"" ;;
esac

py="${HVIS_PYTHON_PATH:-python3}"
if ! "$py" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)' >/dev/null 2>&1; then
  say "note: validation needs Python 3.9+ as python3 (or set HVIS_PYTHON_PATH)"
fi

say "warning: this installer does not update hypervis. Re-run it to get a newer"
say "release, or install with a package manager that handles updates:"
say "  pipx install hypervis   |   cargo install hypervis   |   npx hypervis"
