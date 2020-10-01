resource "azurerm_resource_group" "default" {
  name     = "default-rg"
  location = var.region

  tags = merge(map(
    "Name", "default-rg"
  ), var.tags)
}

resource "azurerm_storage_account" "default" {
  name                     = var.company_unique
  resource_group_name      = azurerm_resource_group.default.name
  location                 = azurerm_resource_group.default.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(map(
    "Name", var.company_unique
  ), var.tags)
}

resource "azurerm_storage_container" "default" {
  name                  = "terraform-tfstates"
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "private"
}
