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

fn run(program: &str, args: &[&str]) -> String {
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

fn sha256(path: &Path) -> String {
    let path = path.to_str().unwrap_or_else(|| die("cache path is not valid UTF-8"));
    let output = if Command::new("sha256sum").arg("--version").output().is_ok() {
        run("sha256sum", &[path])
    } else {
        run("shasum", &["-a", "256", path])
    };
    output.split_whitespace().next().unwrap_or_default().to_owned()
}

fn ensure_binary() -> PathBuf {
    let tag = env::var("HYPERVISUAL_VERSION")
        .unwrap_or_else(|_| format!("v{}", env!("CARGO_PKG_VERSION")));
    let target = target();
    let cache_root = env::var_os("XDG_CACHE_HOME")
        .map(PathBuf::from)
        .or_else(|| env::var_os("HOME").map(|home| PathBuf::from(home).join(".cache")))
        .unwrap_or_else(|| die("neither XDG_CACHE_HOME nor HOME is set"));
    let dir = cache_root.join("hypervisual").join(&tag).join(target);
    let binary = dir.join("codi");
    if binary.exists() {
        return binary;
    }

    let asset = format!("codi-{target}.tar.gz");
    let base = format!("https://github.com/{REPO}/releases/download/{tag}");
    let staging = dir.join(format!(".download-{}", std::process::id()));
    fs::create_dir_all(&staging).unwrap_or_else(|error| die(&format!("cannot create cache dir: {error}")));
    let archive = staging.join(&asset);
    let archive_str = archive.to_str().unwrap_or_else(|| die("cache path is not valid UTF-8"));

    eprintln!("hypervisual: downloading {asset} ({tag})");
    run("curl", &["-fsSL", &format!("{base}/{asset}"), "-o", archive_str]);
    let expected = run("curl", &["-fsSL", &format!("{base}/{asset}.sha256")]);
    let expected = expected.split_whitespace().next().unwrap_or_default();
    if sha256(&archive) != expected {
        let _ = fs::remove_dir_all(&staging);
        die(&format!("checksum mismatch for {asset}"));
    }

    let staging_str = staging.to_str().unwrap_or_else(|| die("cache path is not valid UTF-8"));
    run("tar", &["-xzf", archive_str, "-C", staging_str, "codi"]);
    fs::rename(staging.join("codi"), &binary)
        .unwrap_or_else(|error| die(&format!("cannot install binary into cache: {error}")));
    let _ = fs::remove_dir_all(&staging);
    binary
}

fn main() {
    let binary = ensure_binary();
    let error = Command::new(&binary).args(env::args_os().skip(1)).exec();
    die(&format!("could not run {}: {error}", binary.display()));
}
