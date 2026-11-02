import hashlib
import os
import platform
import sys
import tarfile
import tempfile
import urllib.request
from pathlib import Path

from hypervisual import __version__

REPO = "hypervisual-io/hypervisual"
TARGETS = {
    ("Darwin", "arm64"): "aarch64-apple-darwin",
    ("Linux", "x86_64"): "x86_64-unknown-linux-gnu",
    ("Linux", "amd64"): "x86_64-unknown-linux-gnu",
    ("Linux", "aarch64"): "aarch64-unknown-linux-gnu",
    ("Linux", "arm64"): "aarch64-unknown-linux-gnu",
}


def die(message):
    sys.stderr.write(f"hypervisual: error: {message}\n")
    sys.exit(1)


def download(url):
    try:
        with urllib.request.urlopen(url) as response:
            return response.read()
    except OSError as error:
        die(f"download failed: {url} ({error})")


def ensure_binary():
    tag = os.environ.get("HYPERVISUAL_VERSION") or f"v{__version__}"
    system, machine = platform.system(), platform.machine()
    target = TARGETS.get((system, machine))
    if target is None:
        die(f"no prebuilt binary for {system}/{machine} (available: macOS arm64, Linux x86_64, Linux arm64)")

    cache_root = Path(os.environ.get("XDG_CACHE_HOME") or Path.home() / ".cache")
    directory = cache_root / "hypervisual" / tag / target
    binary = directory / "codi"
    if binary.exists():
        return binary

    asset = f"codi-{target}.tar.gz"
    base = f"https://github.com/{REPO}/releases/download/{tag}"
    sys.stderr.write(f"hypervisual: downloading {asset} ({tag})\n")
    archive = download(f"{base}/{asset}")
    expected = download(f"{base}/{asset}.sha256").decode().split()[0]
    if hashlib.sha256(archive).hexdigest() != expected:
        die(f"checksum mismatch for {asset}")

    directory.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=directory, prefix=".download-") as staging:
        archive_path = Path(staging) / asset
        archive_path.write_bytes(archive)
        with tarfile.open(archive_path) as tar:
            member = tar.getmember("codi")
            tar.extract(member, staging)
        extracted = Path(staging) / "codi"
        extracted.chmod(0o755)
        extracted.replace(binary)
    return binary


def main():
    binary = ensure_binary()
    os.execv(binary, [str(binary), *sys.argv[1:]])
