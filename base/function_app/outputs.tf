output "function_app_url" {
  description = "URL of the Function App"
  value       = azurerm_linux_function_app.function_app.default_hostname
}

output "function_app_principal_id" {
  description = "Principal ID of the Function App"
  value       = azurerm_linux_function_app.function_app.identity[0].principal_id
}