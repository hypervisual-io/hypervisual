#!/usr/bin/env node
"use strict";

const crypto = require("node:crypto");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const { spawnSync } = require("node:child_process");

const REPO = "hypervisual-io/hypervisual";
const TARGETS = {
  "darwin/arm64": "aarch64-apple-darwin",
  "linux/x64": "x86_64-unknown-linux-gnu",
  "linux/arm64": "aarch64-unknown-linux-gnu",
};

function die(message) {
  process.stderr.write(`hypervisual: error: ${message}\n`);
  process.exit(1);
}

async function download(url) {
  const response = await fetch(url);
  if (!response.ok) die(`download failed (${response.status}): ${url}`);
  return Buffer.from(await response.arrayBuffer());
}

async function ensureBinary() {
  const tag = process.env.HYPERVISUAL_VERSION || `v${require("../package.json").version}`;
  const target = TARGETS[`${process.platform}/${process.arch}`];
  if (!target) die(`no prebuilt binary for ${process.platform}/${process.arch} (available: macOS arm64, Linux x64, Linux arm64)`);

  const cacheRoot = process.env.XDG_CACHE_HOME || path.join(os.homedir(), ".cache");
  const dir = path.join(cacheRoot, "hypervisual", tag, target);
  const binary = path.join(dir, "codi");
  if (fs.existsSync(binary)) return binary;

  const asset = `codi-${target}.tar.gz`;
  const base = `https://github.com/${REPO}/releases/download/${tag}`;
  process.stderr.write(`hypervisual: downloading ${asset} (${tag})\n`);
  const archive = await download(`${base}/${asset}`);
  const expected = (await download(`${base}/${asset}.sha256`)).toString("utf8").trim().split(/\s+/)[0];
  const actual = crypto.createHash("sha256").update(archive).digest("hex");
  if (expected !== actual) die(`checksum mismatch for ${asset}`);

  fs.mkdirSync(dir, { recursive: true });
  const staging = fs.mkdtempSync(path.join(dir, ".download-"));
  try {
    const archivePath = path.join(staging, asset);
    fs.writeFileSync(archivePath, archive);
    const untar = spawnSync("tar", ["-xzf", archivePath, "-C", staging], { stdio: "inherit" });
    if (untar.status !== 0) die("could not extract the archive (is `tar` installed?)");
    fs.chmodSync(path.join(staging, "codi"), 0o755);
    fs.renameSync(path.join(staging, "codi"), binary);
  } finally {
    fs.rmSync(staging, { recursive: true, force: true });
  }
  return binary;
}

ensureBinary().then((binary) => {
  const result = spawnSync(binary, process.argv.slice(2), { stdio: "inherit" });
  if (result.error) die(result.error.message);
  process.exit(result.status === null ? 1 : result.status);
}, (error) => die(error.message));
