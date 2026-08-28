# Changelog

This file is not edited by hand. Every change writes its own fragment under
`.changes/unreleased/` with [chlog](https://github.com/luizjhonata/chlog), and a release compiles
the pending fragments into a version section here — so two branches each adding an entry no
longer touch the same lines, and a rebase that used to conflict on this file now conflicts on
nothing.

## [Unreleased]

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

