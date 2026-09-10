# Changelog

This file is not edited by hand. Every change writes its own fragment under
`.changes/unreleased/` with [chlog](https://github.com/luizjhonata/chlog), and a release compiles
the pending fragments into a version section here — so two branches each adding an entry no
longer touch the same lines, and a rebase that used to conflict on this file now conflicts on
nothing.

## [Unreleased]

## [0.5.3] - 2026-09-10

### Changed

- changed the Docker base image `hashicorp/terraform` from `1.16.1` to `1.16.2`

## [0.5.2] - 2026-09-08

### Changed

- changed both `chlog new` examples in the AI-assistant instruction block of `CLAUDE.md` and `.github/copilot-instructions.md` to `--body '<past-tense description>'`: changelog bodies here are written in simple past tense, and the body is single-quoted because it carries backticks that a double-quoted shell argument would command-substitute, and added the line telling the reader to write an apostrophe inside the single-quoted body as `'\''`, since bodies here carry possessives, and switched the 6 other hand-written `chlog new` examples in `CLAUDE.md`, `.github/copilot-instructions.md`, `CONTRIBUTING.md`, and `.github/skills/code-review/SKILL.md` to the same single-quoted body argument
- re-wrapped the secret-hygiene bullet of the `code-review` skill to the file's line width without changing a word of it
- refreshed `CLAUDE.md` and `.github/copilot-instructions.md` to document the `checks.yaml` pull-request workflow
- reworded the secret-hygiene bullet in the `code-review` skill to name the vendor behind each credential prefix and to drop the hyphen from the Slack example, the one shape the shared Gitleaks history scan matches on its own

### Fixed

- regenerated 1 hand-written changelog fragment with `chlog new`, keeping its kind and body, so the filename and the `time` field agree and the next release orders the entries correctly

## [0.5.1] - 2026-09-07

### Changed

- changed the Docker base image `hashicorp/terraform` from `1.6.6` to `1.16.1`

### Fixed

- used the correct Dockerfile filename casing (`.Dockerfile`) in `publish_docker_images.yml` build step so the workflow resolves existing files on Linux runners

### Security

- pinned the third-party actions in `publish_docker_images.yml` (`actions/checkout` to v7.0.1 and `docker/login-action` to v4.6.0) to their full commit SHAs, and locked the `terragrunt-aws` image's `pip install` to a hash-verified, exact-version wheel set in `containers/requirements.txt` (`awscli` 1.46.1, installed with `--only-binary :all: --require-hashes`) so no setup script runs and no unverified file is installed at build time; `--break-system-packages` was added because the image's Alpine 3.19 base marks its Python as externally managed, which already made the previous unpinned install fail. Clears SonarCloud rules githubactions:S7637, docker:S8541 and docker:S8544 on `main`

## [0.5.0] - 2026-09-02

### Added

- added the `checks` workflow, so pull requests here run the shared `code-check > quality:basic-checks` gate (rebase status and the changelog rule) that every repository with a language pipeline already gets as that pipeline's first job. This repository has no build to attach it to, so it had no changelog enforcement at all — which is how the weekly configuration and documentation refresh hand-edited a generated `CHANGELOG.md` across the fleet before anything objected

## [0.4.1] - 2026-09-01

### Changed

- refreshed `CLAUDE.md`, `.github/copilot-instructions.md`, and `.github/skills/code-review/SKILL.md` to match the current codebase: documented the `claude-review.yaml` and `claude-mention.yaml` workflows, corrected the "add a new stack" guidance to use a repo-relative `source` with a symlinked `variables.tf` (not the external GitHub path), and fixed the review skill's `docker build` context to `containers/`

## [0.4.0] - 2026-08-28

### Added

- added the Claude automated code review and `@claude` mention responder workflows, `claude-review.yaml` and `claude-mention.yaml`, matching the `reusable-claude-review.yaml` / `reusable-claude-mention.yaml` definitions they call in `rios0rios0/pipelines`, authenticating with the `CLAUDE_CODE_OAUTH_TOKEN` secret

### Fixed

- restored the `.changes/unreleased/` directory with a `.gitkeep`, so the release tooling keeps recognising this project as [chlog](https://github.com/luizjhonata/chlog)-based after a release consumes the last fragment. Git tracks files rather than directories, so the bump commit that removed the final fragment removed the directory too, and the next run read the empty `[Unreleased]` section as "nothing to release"
- restored the `id-token: write` permission on both Claude workflow callers. Without it the caller grants less than the reusable workflow declares, which GitHub rejects before the job starts -- runs ended in `startup_failure`. The action needs the scope because `setupGitHubToken()` exchanges a GitHub OIDC token for the GitHub App token it posts with, unless a `github_token` is passed explicitly.

### Removed

- removed the unused `id-token: write` permission from the Claude workflow callers, and changed `claude-review.yaml`'s display name to `Claude Review` so it matches its file name and its `Claude Mention` sibling. `anthropics/claude-code-action` needs `id-token: write` only for workload identity federation or the Bedrock / Vertex / Foundry OIDC paths; these authenticate with `claude_code_oauth_token`, so the scope allowed minting OIDC tokens for any audience without ever being used.

## [0.3.0] - 2026-08-26

### Added

- added a tailored `code-review` skill under `.github/skills/` so GitHub Copilot reviews changes against the [rios0rios0/guide](https://github.com/rios0rios0/guide/wiki) standards and this repository's own load-bearing invariants

### Changed

- changed the changelog to [chlog](https://github.com/luizjhonata/chlog) fragments: a change now writes its own YAML file under `.changes/unreleased/` through `chlog new --kind <Kind> --body "..."`, and `CHANGELOG.md` is GENERATED from them at release time by `chlog batch auto && chlog merge`. That is the one thing a single shared file cannot do — two branches each adding an entry no longer touch the same lines, so a rebase that used to conflict on `CHANGELOG.md` now conflicts on nothing. The `[Unreleased]` section was empty, so nothing had to be carried across. AutoBump already reads the fragments directly, so the release flow is unchanged.

## [0.2.2] - 2026-08-24

### Changed

- refreshed `.github/copilot-instructions.md` to add `release.yaml` and the stack's `variables.tf` to the repository structure tree

## [0.2.1] - 2026-07-22

### Changed

- corrected `.github/copilot-instructions.md` to run `terraform validate` from within a module directory instead of the repository root

## [0.2.0] - 2026-05-19

### Added

- created `CLAUDE.md` with build commands, architecture overview, naming conventions, and CI/CD references

### Changed

- refreshed `.github/copilot-instructions.md` to document the `release.yaml` workflow added in the CI/CD section

## [0.1.0] - 2026-04-28

### Changed

- refreshed `.github/copilot-instructions.md` to correct Terraform version references after the 1.6.3 → 1.6.6 upgrade in the AWS container

