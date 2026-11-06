use std::env;
use std::fs;
use std::os::unix::process::CommandExt;
use std::path::{Path, PathBuf};
use std::process::{exit, Command};

const REPO: &str = "hypervisual-io/hypervisual";

fn die(message: &str) -> ! {
    eprintln!("hypervisual: error: {message}");
    exit(1);
}

fn target() -> &'static str {
    match (env::consts::OS, env::consts::ARCH) {
        ("macos", "aarch64") => "aarch64-apple-darwin",
        ("linux", "x86_64") => "x86_64-unknown-linux-gnu",
        ("linux", "aarch64") => "aarch64-unknown-linux-gnu",
        (os, arch) => die(&format!(
            "no prebuilt binary for {os}/{arch} (available: macOS arm64, Linux x86_64, Linux arm64)"
        )),
    }
}

fn command(program: &str, args: &[&str]) -> String {
    let output = Command::new(program)
        .args(args)
        .output()
        .unwrap_or_else(|error| die(&format!("could not run `{program}`: {error}")));
    if !output.status.success() {
        die(&format!(
            "`{program} {}` failed: {}",
            args.join(" "),
            String::from_utf8_lossy(&output.stderr).trim()
        ));
    }
    String::from_utf8_lossy(&output.stdout).into_owned()
}

fn try_curl_to_file(url: &str, dest: &str) -> bool {
    let output = Command::new("curl")
        .args(["-sS", "-L", "-o", dest, "-w", "%{http_code}", url])
        .output()
        .unwrap_or_else(|error| die(&format!("could not run `curl`: {error}")));
    if !output.status.success() {
        let _ = fs::remove_file(dest);
        die(&format!(
            "download failed: {url} ({})",
            String::from_utf8_lossy(&output.stderr).trim()
        ));
    }
    let code = String::from_utf8_lossy(&output.stdout).trim().to_owned();
    if code == "404" {
        let _ = fs::remove_file(dest);
        return false;
    }
    if code != "200" {
        let _ = fs::remove_file(dest);
        die(&format!("download failed: {url} (HTTP {code})"));
    }
    true
}

fn sha256(path: &Path) -> String {
    let path = path.to_str().unwrap_or_else(|| die("cache path is not valid UTF-8"));
    let output = if Command::new("sha256sum").arg("--version").output().is_ok() {
        command("sha256sum", &[path])
    } else {
        command("shasum", &["-a", "256", path])
    };
    output.split_whitespace().next().unwrap_or_default().to_owned()
}

fn archive_member(tar_listing: &str) -> String {
    for line in tar_listing.lines() {
        let line = line.trim();
        if line == "hypervis" || line.ends_with("/hypervis") {
            return line.to_owned();
        }
    }
    for line in tar_listing.lines() {
        let line = line.trim();
        if line == "codi" || line.ends_with("/codi") {
            return line.to_owned();
        }
    }
    die("archive did not contain `hypervis` or `codi`");
}

fn ensure_binary() -> PathBuf {
    let tag = env::var("HYPERVISUAL_VERSION")
        .unwrap_or_else(|_| format!("v{}", env!("CARGO_PKG_VERSION")));
    let target = target();
    let cache_root = env::var_os("XDG_CACHE_HOME")
        .filter(|dir| !dir.is_empty())
        .map(PathBuf::from)
        .or_else(|| env::var_os("HOME").map(|home| PathBuf::from(home).join(".cache")))
        .unwrap_or_else(|| die("neither XDG_CACHE_HOME nor HOME is set"));
    let dir = cache_root.join("hypervisual").join(&tag).join(target);
    let binary = dir.join("hypervis");
    if binary.exists() {
        return binary;
    }

    let staging = dir.join(format!(".download-{}", std::process::id()));
    fs::create_dir_all(&staging).unwrap_or_else(|error| die(&format!("cannot create cache dir: {error}")));
    let archive = staging.join("archive.tar.gz");
    let archive_str = archive.to_str().unwrap_or_else(|| die("cache path is not valid UTF-8"));
    let staging_str = staging.to_str().unwrap_or_else(|| die("cache path is not valid UTF-8"));

    let base = format!("https://github.com/{REPO}/releases/download/{tag}");
    let prefer = format!("hypervis-{target}.tar.gz");
    let fallback = format!("codi-{target}.tar.gz");
    let url_prefer = format!("{base}/{prefer}");
    let url_fallback = format!("{base}/{fallback}");

    let asset = if try_curl_to_file(&url_prefer, archive_str) {
        prefer
    } else if try_curl_to_file(&url_fallback, archive_str) {
        fallback
    } else {
        let _ = fs::remove_dir_all(&staging);
        die(&format!(
            "no release asset {prefer} or {fallback} for {tag}"
        ));
    };

    eprintln!("hypervisual: downloading {asset} ({tag})");
    let sha_url = format!("{base}/{asset}.sha256");
    let expected = command("curl", &["-fsSL", &sha_url]);
    let expected = expected.split_whitespace().next().unwrap_or_default();
    if sha256(&archive) != expected {
        let _ = fs::remove_dir_all(&staging);
        die(&format!("checksum mismatch for {asset}"));
    }

    let listing = command("tar", &["-tzf", archive_str]);
    let member = archive_member(&listing);
    command("tar", &["-xzf", archive_str, "-C", staging_str, &member]);
    let extracted = staging.join(&member);
    fs::rename(&extracted, &binary)
        .unwrap_or_else(|error| die(&format!("cannot install binary into cache: {error}")));
    let _ = fs::remove_dir_all(&staging);
    binary
}

/// Downloads (on first use) and execs the `hypervis` binary with this process's arguments.
pub fn run() -> ! {
    let binary = ensure_binary();
    let error = Command::new(&binary).args(env::args_os().skip(1)).exec();
    die(&format!("could not run {}: {error}", binary.display()));
}
