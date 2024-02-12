output "acr_id" {
  description = "The ID of the Azure Container Registry."
  value       = azurerm_container_registry.default.id
}

output "acr_login_server" {
  description = "The URL of the Docker registry."
  value       = azurerm_container_registry.default.login_server
}

output "acr_admin_username" {
  description = "The username used for Docker registry access."
  value       = azurerm_container_registry.default.admin_username
}

output "acr_admin_password" {
  description = "The password used for Docker registry access."
  value       = azurerm_container_registry.default.admin_password
}
