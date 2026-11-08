# Releasing the CLI

Binaries are built from the private `hypervisual-io/cli` repo by
[`.github/workflows/release.yml`](.github/workflows/release.yml) in this public
repo, which is what lets them carry GitHub build attestations. Publishing the
release then publishes the launcher packages in [`packages/`](packages) through
[`.github/workflows/publish-launchers.yml`](.github/workflows/publish-launchers.yml).

## One-time setup

- Create an SSH key pair. Add the public key to `hypervisual-io/cli` as a
  read-only deploy key and the private key to this repo as the Actions secret
  `CLI_DEPLOY_KEY`.
- In this repo's Settings → Environments, create `npm`, `pypi` and `crates`.
  For each, set Deployment branches and tags to selected ones: branch `main`
  and tag `v*`. Add required reviewers if publishing should wait for approval.
- Register `publish-launchers.yml` as a trusted publisher for each of the five
  packages. Every form uses owner `hypervisual-io`, repository `hypervisual`
  and workflow filename `publish-launchers.yml`; the environment differs:

  | Registry  | Packages                  | Where                                                    | Environment |
  |-----------|---------------------------|----------------------------------------------------------|-------------|
  | npm       | `hypervis`                | package → Settings → Trusted publishing → GitHub Actions  | `npm`       |
  | PyPI      | `hypervisual`, `hypervis` | Your projects → Manage → Publishing → GitHub             | `pypi`      |
  | crates.io | `hypervisual`, `hypervis` | crate → Settings → Trusted Publishing → Add → GitHub     | `crates`    |

  - npm: under Allowed actions, also allow `npm publish`. A new npm trusted
    publisher expires unless it is used within 2 days, so add it shortly before
    the first run. Once that run succeeds, set Publishing access to "Require
    two-factor authentication and disallow tokens".
  - PyPI: remove the old publishers for `release-pypi.yml` (on `hypervisual`)
    and `release-pypi-hypervis.yml` (on `hypervis`); those workflows are gone.

## Each release

1. In `hypervisual-io/cli`, set the `hvis-cli` crate version to `X.Y.Z`, merge,
   and push the tag `vX.Y.Z`. Here, run
   `scripts/set-launcher-version.py X.Y.Z` and merge, so `packages/` matches
   the release (the publish workflow sets the version from the tag anyway).
2. Here, run **Release CLI** (Actions → Run workflow) from `main`, with
   `version` = `vX.Y.Z`. Set `cli_ref` only to build something other than the
   `vX.Y.Z` tag of the CLI repo.
3. The workflow checks the version, builds and smoke-tests the three targets,
   attests the archives and `install.sh`, and creates a **draft** release
   targeting the commit it ran from. The tag is created only when the draft is
   published.
4. Review the draft: assets (3 archives, 3 `.sha256`, `SHA256SUMS`,
   `install.sh`), notes, and `gh attestation verify <asset> --repo
   hypervisual-io/hypervisual` on a downloaded archive.
5. Publish the draft. **Publish launchers** then runs on its own: it sets every
   launcher to `X.Y.Z`, builds them, runs each one against the release assets
   on Linux x86_64, Linux arm64 and macOS arm64, and only then publishes to
   npm, PyPI and crates.io (one job per registry, each waiting for its
   environment's approval if configured). Prereleases and tags other than
   `vX.Y.Z` are skipped.

To retry a CLI release, delete the draft release first; the workflow fails if
the tag or a release (including a draft) for it already exists.

## Re-running the launcher publish

Run **Publish launchers** (Actions → Run workflow) from `main` with `version` =
`vX.Y.Z`, or use "Re-run failed jobs" on the original run. Versions already on
a registry are skipped, so re-runs only publish what is missing. A manual run
packages the launcher code of the branch it runs on.

A release event runs the workflow file from the release's own commit, so
releases whose commit predates `publish-launchers.yml` (v0.2.0) need this
manual run. Publishing a version older than npm's `latest` uses the dist-tag
`backfill`, so `latest` stays on the newest version.

All registries trust the one workflow file. That keeps each trusted publisher
entry the same, but a change to that file affects every registry; the
per-registry jobs, environments and minimal permissions limit what each job
can do. Splitting it would mean one registry entry per file, and moving publish
steps into reusable workflows does not work: PyPI does not accept reusable
workflows and npm checks the calling workflow's filename.
