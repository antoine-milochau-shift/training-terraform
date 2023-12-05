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

variable "containers" {
  description = "Containers, used by Blob Services"
  type        = map(object({}))
  default     = {}
}