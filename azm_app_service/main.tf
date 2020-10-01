resource "azurerm_resource_group" "default" {
  name     = "${terraform.workspace}-${var.stack}-rg"
  location = var.region

  tags = merge(map(
    "Name", "${terraform.workspace}-${var.stack}-rg"
  ), var.tags)
}

resource "azurerm_app_service_plan" "default" {
  name                = "${terraform.workspace}-${var.name}-appsp"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  sku {
    tier = "Free"
    size = "F1"
  }

  tags = merge(map(
    "Name", "${terraform.workspace}-${var.name}-appsp"
  ), var.tags)
}

resource "azurerm_app_service" "default" {
  name                = "${terraform.workspace}-${var.name}-app"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  app_service_plan_id = azurerm_app_service_plan.default.id
  app_settings        = {}

  site_config {
    dotnet_framework_version  = "v4.0"
    use_32_bit_worker_process = true
    managed_pipeline_mode     = "Classic"
    default_documents = [
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php",
    "hostingstart.html"]
  }

  lifecycle {
    ignore_changes = [
      site_config.0.scm_type
    ]
  }

  tags = merge(map(
    "Name", "${terraform.workspace}-${var.name}-app"
  ), var.tags)
}

resource "azurerm_app_service_source_control_token" "default" {
  type  = "GitHub"
  token = var.github_token
}

resource "null_resource" "scm_integration" {
  triggers = {
    service  = join("/", [azurerm_resource_group.default.name, azurerm_app_service.default.name]),
    repo_url = join("/", [var.github_repository, var.github_branch])
  }

  provisioner "local-exec" {
    command = join("", ["${path.module}/scripts/scm_integration.ps1",
      " -resourceGroupName ${azurerm_resource_group.default.name}",
      " -appServiceName ${azurerm_app_service.default.name}",
    " -repository ${var.github_repository} -branch ${var.github_branch}"])
    interpreter = ["pwsh", "-Command"]
  }
}
