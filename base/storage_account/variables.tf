variable "name_suffix" {
  description = "Suffix used for the resources name"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "containers" {
  description = "Containers, used by Blob Services"
  type        = map(object({}))
  default     = {}
}