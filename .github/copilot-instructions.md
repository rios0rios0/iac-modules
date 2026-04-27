# Copilot Instructions

## Project Overview

`iac-modules` is a collection of reusable Terraform modules, Terragrunt container images, and pre-composed infrastructure stack templates targeting Azure and AWS. The repository provides standardized, production-ready building blocks so that teams can provision cloud resources consistently without duplicating configuration across projects.

## Repository Structure

```
iac-modules/
├── .github/
│   └── workflows/
│       └── publish_docker_images.yml  # CI/CD: builds and publishes Docker images on release
├── containers/
│   ├── entrypoint.sh                  # Flexible entrypoint (directory or command invocation mode)
│   ├── terragrunt-aws.Dockerfile      # Terraform + Terragrunt + AWS CLI runner image
│   └── terragrunt-azm.Dockerfile      # Terraform + Terragrunt + Azure CLI runner image
├── modules/
│   ├── azm_app_service/               # Azure App Service with GitHub SCM deployment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── scripts/
│   │       └── scm_integration.ps1    # PowerShell script for GitHub source control integration
│   ├── azm_container_registry/        # Azure Container Registry with token auth and webhooks
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── azm_storage_container/         # Azure Storage Account + Container (e.g., remote state)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── stacks/
│   └── azm_app_service/               # Pre-composed App Service stack for direct Terragrunt use
│       ├── main.tf
│       └── outputs.tf
├── CHANGELOG.md
├── CONTRIBUTING.md
└── README.md
```

### Key Directories

- **`modules/`** — Reusable Terraform modules. Each module is a self-contained directory with `main.tf`, `variables.tf`, and `outputs.tf`. Add new modules here following the `azm_` (Azure) or `aws_` (AWS) naming prefix convention.
- **`stacks/`** — Pre-composed templates that wire one or more modules together with all required variables. Designed for direct use with Terragrunt.
- **`containers/`** — Dockerfiles and the shared `entrypoint.sh` for Terragrunt runner images. Images are published to GitHub Packages on every release.

## Technology Stack

| Component | Version / Details |
|---|---|
| Terraform | 1.6.6 (AWS image), 1.6.3 (Azure image) |
| Terragrunt | 0.53.2 |
| Azure Provider | `azurerm` (latest) |
| PowerShell Core | `pwsh` — used for SCM integration scripts |
| Docker | `hashicorp/terraform:1.6.6` base (AWS), `azurestack/powershell` base (Azure) |
| Azure CLI | Installed in `terragrunt-azm` image |
| AWS CLI | Installed in `terragrunt-aws` image |

## Development Workflow

1. Fork and clone the repository.
2. Create a feature branch: `git checkout -b feat/my-change`
3. Make changes to the relevant module or stack.
4. **Validate and format** (run from the repository root):
   ```bash
   terraform fmt -recursive   # auto-format all .tf files
   terraform validate         # validate syntax and configuration
   ```
5. Update `CHANGELOG.md` under the `[Unreleased]` section.
6. Commit following the [commit conventions](https://github.com/rios0rios0/guide/wiki/Life-Cycle/Git-Flow) (Conventional Commits: `feat:`, `fix:`, `chore:`, etc.).
7. Open a pull request against `main`.

## Build Commands

### Docker images (Terragrunt runners)

```bash
# Azure variant
docker build -t terragrunt-azm -f containers/terragrunt-azm.Dockerfile containers/

# AWS variant
docker build -t terragrunt-aws -f containers/terragrunt-aws.Dockerfile containers/
```

### Run a container against a local Terragrunt project

```bash
# Directory-based invocation (entrypoint receives the working directory as first arg)
docker run --rm -v "$(pwd):/app" terragrunt-azm /app terragrunt plan

# Command-based invocation (entrypoint receives a raw command)
docker run --rm -v "$(pwd):/app" terragrunt-aws terraform init
```

## Architecture and Design Patterns

### Module composition pattern

- **Modules** define a single Azure/AWS resource or a tightly related group of resources with standardized `variables.tf` inputs and `outputs.tf` outputs.
- **Stacks** compose modules and hard-wire sensible defaults, providing a ready-to-consume configuration for Terragrunt deployments.
- **Containers** package the execution environment so that no local Terraform/Terragrunt installation is required.

### Naming conventions

- Module directories use the cloud prefix followed by a snake_case resource name: `azm_<resource>` (Azure), `aws_<resource>` (AWS).
- Terraform resources inside modules use descriptive, lowercase names consistent with the module's purpose.
- Variables and outputs follow Terraform community style: `snake_case` names, with `description` and `type` attributes always present.

### Module structure

Every module must contain:
- `main.tf` — resource definitions
- `variables.tf` — all input variables with `type`, `description`, and `default` (where applicable)
- `outputs.tf` — exported values

### PowerShell provisioners

The `azm_app_service` module uses a PowerShell `local-exec` provisioner (`scripts/scm_integration.ps1`) to configure GitHub SCM integration after the App Service is created. Ensure `pwsh` is available in the execution environment (it is pre-installed in the `terragrunt-azm` image).

## CI/CD Pipeline

**Workflow:** `.github/workflows/publish_docker_images.yml`

- **Trigger:** GitHub release published
- **Action:** Builds both `terragrunt-aws` and `terragrunt-azm` Docker images and pushes them to GitHub Packages (`docker.pkg.github.com`) tagged with the release version and `latest`.
- **Registry:** `ghcr.io/rios0rios0/iac-modules/<image-name>` (the workflow currently uses the legacy `docker.pkg.github.com` endpoint — update to `ghcr.io` when modernizing the pipeline)

No CI validation workflow runs on pull requests at present; validation is done locally by the developer before opening a PR.

## Coding Conventions

- Follow the [Development Guide](https://github.com/rios0rios0/guide/wiki) for commit messages, branching strategy, and coding standards.
- Always run `terraform fmt -recursive` before committing; unformatted code should not be merged.
- Always run `terraform validate` from the module directory to catch syntax errors before committing.
- Keep modules focused: one module = one logical resource or tightly coupled resource group.
- Document every variable and output with a `description` attribute.
- Record all user-visible changes in `CHANGELOG.md` under `[Unreleased]` using [Keep a Changelog](https://keepachangelog.com/) format.

## Common Tasks

### Add a new Terraform module

1. Create a directory under `modules/` with the appropriate prefix (e.g., `modules/azm_my_resource/`).
2. Add `main.tf`, `variables.tf`, and `outputs.tf`.
3. Document variables and outputs with `description` attributes.
4. Run `terraform fmt -recursive` and `terraform validate` inside the new directory.
5. Add an entry under `[Unreleased]` in `CHANGELOG.md`.

### Add a new stack

1. Create a directory under `stacks/` (e.g., `stacks/azm_my_stack/`).
2. Reference the relevant module(s) using the GitHub source path: `github.com/rios0rios0/iac-modules//modules/<module_name>`.
3. Wire all required variables in `main.tf` and expose key values in `outputs.tf`.

### Update the Terragrunt runner images

1. Modify the relevant Dockerfile in `containers/`.
2. Rebuild and test locally (see Build Commands above).
3. Changes are published automatically when a new GitHub release is created.

## Troubleshooting

- **`terraform validate` fails after `fmt`:** Ensure you are running `validate` from within the module directory, not the repository root (which has no root-level `.tf` files).
- **Docker image build fails:** Check that the `containers/` context path is provided correctly — the build context must be `containers/`, not the repo root.
- **PowerShell provisioner fails:** Verify that `pwsh` (PowerShell Core) is installed in the execution environment or use the `terragrunt-azm` Docker image which includes it.
