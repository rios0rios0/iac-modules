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
- Record changes in `CHANGELOG.md` under `[Unreleased]` using Keep a Changelog format.
- The `azm_app_service` module uses a PowerShell `local-exec` provisioner — `pwsh` must be available.

## CI/CD

- `publish_docker_images.yml` — builds and pushes container images to GitHub Packages on release.
- `release.yaml` — triggers on push to `main`, calls reusable workflow from `rios0rios0/pipelines` to create version tags.
- No PR validation workflow; validate locally.
