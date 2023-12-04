output "function_app_url" {
  description = "URL of the Function App"
  value       = "https://${module.function_app.function_app_url}/api/test"
}