# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Codex, Cursor, GitHub Copilot) when working with code in this repository.

## Overview

Reusable Terraform modules, Terragrunt runner containers, and pre-composed stacks for Azure and AWS.

## Architecture

- `modules/` — Self-contained Terraform modules. Each must have `main.tf`, `variables.tf`, `outputs.tf`.
- `stacks/` — Compositions wiring modules with defaults for direct Terragrunt use.
- `containers/` — Dockerfiles and entrypoint for Terragrunt runner images (Azure CLI or AWS CLI).

Modules are referenced externally via `github.com/rios0rios0/iac-modules//modules/<name>`.

## Naming Conventions

- Module directories: `azm_<resource>` (Azure), `aws_<resource>` (AWS).
- Variables and outputs: `snake_case` with `type` and `description` always present.

## Build & Validate

```bash
terraform fmt -recursive        # format all .tf files
terraform validate               # run from within the module directory, not repo root
docker build -t terragrunt-azm -f containers/terragrunt-azm.Dockerfile containers/
docker build -t terragrunt-aws -f containers/terragrunt-aws.Dockerfile containers/
```

## Versions

Pinned versions live in the sources, not here: Terraform and Terragrunt in `containers/terragrunt-*.Dockerfile`
(the AWS image's `FROM hashicorp/terraform:<ver>` tag is bumped automatically; the Azure image pins `TERRAFORM_VER`,
so the two differ), and the hash-locked AWS CLI in `containers/requirements.txt`.

## Conventions

- Commits follow Conventional Commits (`feat:`, `fix:`, `chore:`) per the [Development Guide](https://github.com/rios0rios0/guide/wiki).
- Always run `terraform fmt -recursive` before committing.
- Record changes with `chlog new --kind <Kind> --body '...'`, which writes a fragment under
  `.changes/unreleased/`. `CHANGELOG.md` is generated from those fragments and is never edited by hand.
- The `azm_app_service` module uses a PowerShell `local-exec` provisioner — `pwsh` must be available.

## CI/CD

- No workflow runs `terraform validate` on pull requests (they run the shared `rios0rios0/pipelines` checks and an
  automated review), so validate every touched module locally.
- `publish_docker_images.yml` builds both runner images only when a GitHub release is published.
- `release.yaml` creates version tags on push to `main` via `rios0rios0/pipelines`.

<!-- chlog:start -->
## Changelog (chlog) — MANDATORY

If the repository you are working in uses chlog (a `.chlog.yaml` or `.chlog.yml`
config file, or a `.changes/` directory, exists at the project root), the
following is binding and ALWAYS applies: whenever you make ANY change, you MUST
create a changelog fragment as part of the same change — automatically, without
being asked, before committing.

- Do NOT edit CHANGELOG.md directly; it is generated from fragments.
- Create the fragment with:
  `chlog new --kind <Kind> --body '<past-tense description>'`
- Write an apostrophe inside the single-quoted body as `'\''`.
- Valid kinds: Added, Changed, Deprecated, Removed, Fixed, Security
- Choose the kind that best matches the change (e.g., new feature → Added,
  bug fix → Fixed, behavior change → Changed, removal → Removed, security fix → Security).
- If the change is backward-INCOMPATIBLE with the public API (a breaking
  change), you MUST add the `--breaking` flag:
  `chlog new --kind <Kind> --breaking --body '<past-tense description>'`.
  This is the ONLY thing that triggers a major version bump — the kind alone
  never does (per SemVer, major = incompatible change). When unsure whether a
  change breaks compatibility, ask the user instead of guessing.
- Fragments are YAML files in `.changes/unreleased/`; stage them with your commit.
- `chlog check` fails the build when a fragment is missing — never skip it.
<!-- chlog:end -->
