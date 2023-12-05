variable "context" {
  description = "Deployment context, used to create resources properly"
  type = object({
    organization = string
    region       = string
    environment  = string
    workload     = string
    project      = string
  })
}

variable "resource_group_name" {
  description = "The name of the Resource Group, where to deploy resources"
  type        = string
}

variable "storage_accounts" {
  description = "Storage Accounts, used to persist data - the map key is the instance of the Storage Account"
  type = map(object({
    containers = map(object({}))
  }))
  default = {}
}

variable "function_app_src" {
  description = "Path of the files, as source file root folder path, of the Function App"
  type        = string
}