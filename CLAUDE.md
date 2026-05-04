# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`iac-modules` is a collection of reusable Terraform modules, Terragrunt container images, and pre-composed infrastructure stack templates for Azure and AWS.

## Architecture

- `modules/` — Self-contained Terraform modules. Each has `main.tf`, `variables.tf`, `outputs.tf`.
- `stacks/` — Pre-composed templates wiring modules together for direct Terragrunt use.
- `containers/` — Dockerfiles and entrypoint for Terragrunt runner images (Azure CLI and AWS CLI variants).

Modules define a single resource or tightly coupled group. Stacks compose modules and hard-wire defaults. Containers package the execution environment so no local Terraform/Terragrunt install is needed.

## Commands

```bash
# Format all Terraform files
terraform fmt -recursive

# Validate a module (run from inside the module directory, not repo root)
cd modules/azm_app_service && terraform validate

# Build Docker images
docker build -t terragrunt-azm -f containers/terragrunt-azm.Dockerfile containers/
docker build -t terragrunt-aws -f containers/terragrunt-aws.Dockerfile containers/
```

## Conventions

- Module directories use cloud prefix + snake_case: `azm_<resource>` (Azure), `aws_<resource>` (AWS).
- Every variable and output must have a `description` attribute.
- Run `terraform validate` from inside the module directory, not the repo root (no root-level `.tf` files).
- Always run `terraform fmt -recursive` before committing.
- Commits follow Conventional Commits (`feat:`, `fix:`, `chore:`, etc.) per the [Development Guide](https://github.com/rios0rios0/guide/wiki).
- Update `CHANGELOG.md` under `[Unreleased]` for all user-visible changes using [Keep a Changelog](https://keepachangelog.com/) format.

## CI/CD

- `release.yaml` — auto-creates releases on push to `main` via reusable workflow from `rios0rios0/pipelines`.
- `publish_docker_images.yml` — builds and pushes both runner images to GitHub Packages on release.
- No PR validation workflow; validation is done locally.
