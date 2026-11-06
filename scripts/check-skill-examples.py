#!/usr/bin/env python3
"""Validate every diagram example in skills/ with the hypervis CLI.

Checks each `*.hvis` file, plus each fenced Markdown block whose first
non-comment line is a diagram declaration such as `Login[sequence]:`.
Fragments without a declaration are skipped.

usage: scripts/check-skill-examples.py [--bin hypervis] [--only SKILL_DIR] [-v]
"""
import argparse
import pathlib
import re
import subprocess
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
FENCE = re.compile(r"^```(\w*)\s*$")
DECLARATION = re.compile(r"^[^\s#-][^:]*\[[\w-]+\]\s*:\s*$")


def examples(base):
    for f in sorted(base.rglob("*.hvis")):
        yield f.relative_to(ROOT), 1, f.read_text()
    for md in sorted(base.rglob("*.md")):
        lines = md.read_text().splitlines()
        block, lang, start = None, "", 0
        for n, line in enumerate(lines, 1):
            m = FENCE.match(line)
            if block is None and m:
                block, lang, start = [], m.group(1), n
            elif block is not None and line.startswith("```"):
                body = [l for l in block if l.strip() and not l.lstrip().startswith("#")]
                if lang in ("yaml", "hvis", "codi", "") and body and DECLARATION.match(body[0]):
                    yield md.relative_to(ROOT), start, "\n".join(block) + "\n"
                block = None
            elif block is not None:
                block.append(line)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--bin", default="hypervis")
    ap.add_argument("--only", help="limit to one skill directory, e.g. hypervis-gantt")
    ap.add_argument("-v", "--verbose", action="store_true")
    args = ap.parse_args()

    base = ROOT / "skills" / (args.only or "")
    total = failed = 0
    with tempfile.TemporaryDirectory() as tmp:
        for path, line, source in examples(base):
            total += 1
            f = pathlib.Path(tmp) / f"example{total}.hvis"
            f.write_text(source)
            r = subprocess.run([args.bin, "validate", str(f)], capture_output=True, text=True)
            if r.returncode != 0:
                failed += 1
                print(f"FAIL {path}:{line}")
                if args.verbose:
                    out = (r.stdout + r.stderr).strip().splitlines()
                    print("\n".join("    " + l for l in out[:6]))
            elif args.verbose:
                print(f"ok   {path}:{line}")
    print(f"{total - failed}/{total} examples validate")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
