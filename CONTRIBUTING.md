# Contributing

Contributions are welcome. By participating, you agree to maintain a respectful and constructive environment.

For coding standards, testing patterns, architecture guidelines, commit conventions, and all
development practices, refer to the **[Development Guide](https://github.com/rios0rios0/guide/wiki)**.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) 1.0+

## Development Workflow

1. Fork and clone the repository
2. Create a branch: `git checkout -b feat/my-change`
3. Make your changes to the relevant module under the module directory
4. Validate:
   ```bash
   terraform fmt -recursive
   terraform validate
   ```
5. Update `CHANGELOG.md` under `[Unreleased]`
6. Commit following the [commit conventions](https://github.com/rios0rios0/guide/wiki/Life-Cycle/Git-Flow)
7. Open a pull request against `main`
