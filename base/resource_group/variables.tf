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