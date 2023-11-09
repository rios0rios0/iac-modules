output "resource_group_id" {
  value       = azurerm_resource_group.default.id
  description = "The id of the resource group."
}

output "resource_group_name" {
  value       = azurerm_resource_group.default.name
  description = "The name of the resource group."
}

output "storage_account_id" {
  value       = azurerm_storage_account.default.id
  description = "The id of the storage account."
}

output "storage_account_name" {
  value       = azurerm_storage_account.default.name
  description = "The name of the storage account."
}

output "storage_container_name" {
  value       = azurerm_storage_container.default.name
  description = "The name of the storage container."
}

output "storage_container_id" {
  value       = azurerm_storage_container.default.id
  description = "The id of the storage container."
}
