#!/usr/bin/env python3
"""Set the version of every launcher package in packages/.

Each launcher downloads the release whose tag is `v<its version>`, so all of
them (and the alias packages' pins on `hypervisual`) must carry the release
version.

usage: scripts/set-launcher-version.py 1.2.3
"""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent / "packages"
VERSION = re.compile(r"^\d+\.\d+\.\d+$")


def lock_entry(name):
    return rf'(\[\[package\]\]\nname = "{name}"\nversion = ")[^"]*(")'


# (file, pattern with the version between groups 1 and 2)
EDITS = [
    ("npm/package.json", r'^(  "version": ")[^"]*(",)$'),
    ("pypi/pyproject.toml", r'^(version = ")[^"]*(")$'),
    ("pypi/src/hypervisual/__init__.py", r'^(__version__ = ")[^"]*(")$'),
    ("pypi-hypervis/pyproject.toml", r'^(version = ")[^"]*(")$'),
    ("pypi-hypervis/pyproject.toml", r'("hypervisual==)[^"]*(")'),
    ("crate/Cargo.toml", r'^(version = ")[^"]*(")$'),
    ("crate-hypervis/Cargo.toml", r'^(version = ")[^"]*(")$'),
    ("crate-hypervis/Cargo.toml", r'^(hypervisual = \{ version = ")[^"]*(")'),
    ("Cargo.lock", lock_entry("hypervis")),
    ("Cargo.lock", lock_entry("hypervisual")),
]


def main():
    if len(sys.argv) != 2 or not VERSION.match(sys.argv[1]):
        sys.exit("usage: scripts/set-launcher-version.py X.Y.Z")
    version = sys.argv[1]
    for name, pattern in EDITS:
        path = ROOT / name
        text, count = re.subn(
            pattern, rf"\g<1>{version}\g<2>", path.read_text(), flags=re.MULTILINE
        )
        if count != 1:
            sys.exit(f"{path}: expected one match for {pattern!r}, found {count}")
        path.write_text(text)
    print(f"launcher packages set to {version}")


if __name__ == "__main__":
    main()
