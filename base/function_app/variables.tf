variable "name_suffix" {
  description = "Suffix used for the resources name"
  type        = string
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