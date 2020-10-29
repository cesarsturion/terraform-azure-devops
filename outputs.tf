output "app-service-api-default-site-hostname" {
  value = azurerm_app_service.app-service-api.default_site_hostname
}

output "app-service-web-default-site-hostname" {
  value = azurerm_app_service.app-service-web.default_site_hostname
}