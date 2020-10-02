output "id_resource_group" {
  description = "The id of the resource group"
  value       = azurerm_resource_group.default.id
}

output "id_storage_account" {
  description = "The id of the storage account"
  value       = azurerm_storage_account.default.id
}

output "id_storage_container" {
  description = "The id of the storage container"
  value       = azurerm_storage_container.default.id
}
