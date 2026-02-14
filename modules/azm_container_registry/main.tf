resource "azurerm_container_registry" "default" {
  sku                 = var.sku
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  admin_enabled       = false
  tags                = var.tags
}

resource "azurerm_container_registry_token" "default" {
  name                    = "acrToken"
  container_registry_id   = azurerm_container_registry.default.id
  scope_map_id            = azurerm_container_registry_scope_map.default.id
  container_registry_name = azurerm_container_registry.default.name
  resource_group_name     = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_container_registry_token_password" "default" {
  password_name               = "password1"
  token_id                    = azurerm_container_registry_token.default.id
  container_registry_token_id = azurerm_container_registry_token.default.id
  tags                = var.tags
}

resource "azurerm_container_registry_scope_map" "default" {
  name                    = "acrScopeMap"
  container_registry_id   = azurerm_container_registry.default.id
  actions                 = ["repositories/hello-world/content/read"]
  container_registry_name = azurerm_container_registry.default.name
  resource_group_name     = var.resource_group_name
  tags                = var.tags
}



resource "azurerm_container_registry_webhook" "default" {
  name                    = "acrWebhook"
  location                = var.location
  resource_group_name     = var.resource_group_name
  container_registry_name = azurerm_container_registry.default.name
  service_uri             = "http://example.com"
  status                  = "enabled"
  scope                   = "${var.repository_name}:latest"
  actions                 = ["push"]

  custom_headers = {
    "X-Custom-Header" = "terraform"
  }
}
