variable "context" {
  description = "Deployment context, used to create resources properly"
  type = object({
    organization = string
    region       = string
    environment  = string
    workload     = string
    project      = string
    instance     = string
  })
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "function_app_src" {
  description = "Path of the files, as source file root folder path, of the Function App"
  type        = string
}

variable "extra_app_settings" {
  description = "Extraneous configuration to add into the Function App app settings"
  type        = map(string)
  default     = {}
}