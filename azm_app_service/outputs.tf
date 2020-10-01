output "id" {
  description = "The id of the web app"
  value       = azurerm_app_service.default.id
}

output "host" {
  description = "The host of the web app"
  value       = azurerm_app_service.default.default_site_hostname
}
