resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(
    { Name = var.resource_group_name },
    var.tags
  )
}

resource "azurerm_storage_account" "default" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.default.name
  location                 = azurerm_resource_group.default.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(
    { Name = var.storage_account_name },
    var.tags
  )
}

resource "azurerm_storage_container" "default" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "private"
}
