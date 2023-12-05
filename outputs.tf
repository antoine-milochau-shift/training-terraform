output "function_app_url" {
  description = "URL of the Function App"
  value       = "https://${module.function_app_with_storage.function_app_default_hostname}/api/test"
}