# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

- Terraform: 1.6.6 (AWS image), 1.6.3 (Azure image)
- Terragrunt: 0.53.2

## Conventions

- Commits follow Conventional Commits (`feat:`, `fix:`, `chore:`) per the [Development Guide](https://github.com/rios0rios0/guide/wiki).
- Always run `terraform fmt -recursive` before committing.
- Record changes with `chlog new --kind <Kind> --body "..."`, which writes a fragment under
  `.changes/unreleased/`. `CHANGELOG.md` is generated from those fragments and is never edited by hand.
- The `azm_app_service` module uses a PowerShell `local-exec` provisioner — `pwsh` must be available.

## CI/CD

- `publish_docker_images.yml` — builds and pushes container images to GitHub Packages on release.
- `release.yaml` — triggers on push to `main`, calls reusable workflow from `rios0rios0/pipelines` to create version tags.
- No PR validation workflow; validate locally.

<!-- chlog:start -->
## Changelog (chlog) — MANDATORY

If the repository you are working in uses chlog (a `.chlog.yaml` or `.chlog.yml`
config file, or a `.changes/` directory, exists at the project root), the
following is binding and ALWAYS applies: whenever you make ANY change, you MUST
create a changelog fragment as part of the same change — automatically, without
being asked, before committing.

- Do NOT edit CHANGELOG.md directly; it is generated from fragments.
- Create the fragment with:
  `chlog new --kind <Kind> --body "<imperative description>"`
- Valid kinds: Added, Changed, Deprecated, Removed, Fixed, Security
- Choose the kind that best matches the change (e.g., new feature → Added,
  bug fix → Fixed, behavior change → Changed, removal → Removed, security fix → Security).
- If the change is backward-INCOMPATIBLE with the public API (a breaking
  change), you MUST add the `--breaking` flag:
  `chlog new --kind <Kind> --breaking --body "<description>"`.
  This is the ONLY thing that triggers a major version bump — the kind alone
  never does (per SemVer, major = incompatible change). When unsure whether a
  change breaks compatibility, ask the user instead of guessing.
- Fragments are YAML files in `.changes/unreleased/`; stage them with your commit.
- `chlog check` fails the build when a fragment is missing — never skip it.
<!-- chlog:end -->
