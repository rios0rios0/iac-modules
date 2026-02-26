<h1 align="center">IaC Modules</h1>
<p align="center">
    <a href="https://github.com/rios0rios0/iac-modules/releases/latest">
        <img src="https://img.shields.io/github/release/rios0rios0/iac-modules.svg?style=for-the-badge&logo=github" alt="Latest Release"/></a>
    <a href="https://github.com/rios0rios0/iac-modules/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/rios0rios0/iac-modules.svg?style=for-the-badge&logo=github" alt="License"/></a>
</p>

A collection of reusable Terraform modules, Terragrunt container images, and pre-composed infrastructure stack templates targeting Azure and AWS. The repository provides standardized, production-ready building blocks so that teams can provision cloud resources consistently without duplicating configuration across projects.

## Features

- **Azure App Service module** (`azm_app_service`) -- provisions a resource group, App Service plan (Free/F1 tier), App Service instance with .NET 4.0 site config, optional Azure Files storage mount, and automated GitHub SCM integration via a PowerShell provisioner
- **Azure Container Registry module** (`azm_container_registry`) -- creates an ACR instance with token-based authentication, scope maps, and a push webhook for image promotion workflows
- **Azure Storage Container module** (`azm_storage_container`) -- sets up a resource group, Standard LRS storage account (TLS 1.2, private access), and a storage container (defaults to `terraform-tfstates` for remote state)
- **App Service stack** (`azm_app_service`) -- a ready-to-use composition that wires the App Service module with all required variables, suitable for direct use with Terragrunt
- **Terragrunt container images** -- Docker images bundling Terraform 1.6.3 + Terragrunt 0.53.2 with either Azure CLI (`terragrunt-azm`) or AWS CLI (`terragrunt-aws`) pre-installed, with a flexible entrypoint that accepts both directory-based and command-based invocations

## Technologies

- [Terraform](https://www.terraform.io/) 1.6.3
- [Terragrunt](https://terragrunt.gruntwork.io/) 0.53.2
- [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest) (`azurerm`)
- [PowerShell Core](https://github.com/PowerShell/PowerShell) (`pwsh`) for SCM integration scripts
- [Docker](https://www.docker.com/) for Terragrunt runner containers

## Project Structure

```
iac-modules/
├── containers/
│   ├── entrypoint.sh                  # Flexible entrypoint (directory or command mode)
│   ├── terragrunt-aws.Dockerfile      # Terraform + Terragrunt + AWS CLI
│   └── terragrunt-azm.Dockerfile      # Terraform + Terragrunt + Azure CLI
├── modules/
│   ├── azm_app_service/               # Azure App Service with GitHub deployment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── scripts/
│   │       └── scm_integration.ps1    # PowerShell script for SCM source control
│   ├── azm_container_registry/        # Azure Container Registry with tokens/webhooks
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── azm_storage_container/         # Azure Storage Account + Container
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── stacks/
│   └── azm_app_service/               # Pre-composed App Service stack
│       ├── main.tf
│       └── outputs.tf
├── CHANGELOG.md
├── LICENSE
└── README.md
```

## Installation

Reference modules directly from the repository in your Terraform configuration:

```hcl
module "app_service" {
  source = "github.com/rios0rios0/iac-modules//modules/azm_app_service"

  region              = "eastus"
  stack               = "web"
  environment         = "production"
  github_branch       = "main"
  github_repository   = "https://github.com/org/repo"
  github_token        = var.github_token
  tags                = { Team = "platform" }
}
```

```hcl
module "storage" {
  source = "github.com/rios0rios0/iac-modules//modules/azm_storage_container"

  location             = "eastus"
  resource_group_name  = "tfstate-rg"
  storage_account_name = "myorgterraformstate"
  tags                 = { Purpose = "terraform-state" }
}
```

## Usage

### Using the Terragrunt containers

Build and run the Azure variant:

```bash
docker build -t terragrunt-azm -f containers/terragrunt-azm.Dockerfile containers/
docker run --rm -v "$(pwd):/app" terragrunt-azm /app terragrunt plan
```

Build and run the AWS variant:

```bash
docker build -t terragrunt-aws -f containers/terragrunt-aws.Dockerfile containers/
docker run --rm -v "$(pwd):/app" terragrunt-aws /app terragrunt apply
```

### Module inputs and outputs

Each module directory contains `variables.tf` (inputs) and `outputs.tf` (outputs). Key outputs include:

| Module | Outputs |
|--------|---------|
| `azm_app_service` | `id`, `host` |
| `azm_container_registry` | `acr_id`, `acr_login_server`, `acr_admin_username`, `acr_admin_password` |
| `azm_storage_container` | `resource_group_id`, `resource_group_name`, `storage_account_id`, `storage_account_name`, `storage_container_id`, `storage_container_name` |

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.
