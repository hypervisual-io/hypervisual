# Releasing the CLI

Binaries are built from the private `hypervisual-io/cli` repo by
[`.github/workflows/release.yml`](.github/workflows/release.yml) in this public
repo, which is what lets them carry GitHub build attestations.

## One-time setup

- Create an SSH key pair. Add the public key to `hypervisual-io/cli` as a
  read-only deploy key and the private key to this repo as the Actions secret
  `CLI_DEPLOY_KEY`.

## Each release

1. In `hypervisual-io/cli`, set the `hvis-cli` crate version to `X.Y.Z`, merge,
   and push the tag `vX.Y.Z`.
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
5. Publish the draft. Then bump and publish the launcher packages
   (`packages/`) for the same version.

To retry, delete the draft release first; the workflow fails if the tag or a
release (including a draft) for it already exists.
