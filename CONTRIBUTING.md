# Contributing

Contributions are welcome. By participating, you agree to maintain a respectful and constructive environment.

For coding standards, testing patterns, architecture guidelines, commit conventions, and all
development practices, refer to the **[Development Guide](https://github.com/rios0rios0/guide/wiki)**.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) 1.6.3+
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) 0.53.2+ (for stack testing)
- [Docker](https://docs.docker.com/get-docker/) 20.10+ (for building Terragrunt container images)
- [Git](https://git-scm.com/downloads) 2.30+

## Development Workflow

1. Fork and clone the repository
2. Create a branch: `git checkout -b feat/my-change`
3. Navigate to the module you want to modify (e.g., `modules/azm_app_service/`)
4. Initialize the Terraform module:
   ```bash
   cd modules/azm_app_service
   terraform init
   ```
5. Format and validate your changes:
   ```bash
   terraform fmt -recursive
   terraform validate
   ```
6. Build the Terragrunt container images (if modifying containers):
   ```bash
   docker build -t terragrunt-azm -f containers/terragrunt-azm.Dockerfile containers/
   docker build -t terragrunt-aws -f containers/terragrunt-aws.Dockerfile containers/
   ```
7. Test the container entrypoint:
   ```bash
   docker run --rm -v "$(pwd):/app" terragrunt-azm /app terragrunt plan
   ```
8. Update `CHANGELOG.md` under `[Unreleased]`
9. Commit following the [commit conventions](https://github.com/rios0rios0/guide/wiki/Life-Cycle/Git-Flow)
10. Open a pull request against `main`
