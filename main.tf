locals {
  context = {
    organization = "sh"
    region       = "frc1"
    environment  = "sdbx"
    workload     = "comp"
    project      = "shrd"
  }
  storage_accounts = {
    1 = {
      containers = {
        content = {}
      }
    }
  }
  function_app_src = "./src"
}

module "resource_group" {
  source = "./base/resource_group"
  context = merge(local.context, {
    instance = "1"
  })
}

module "function_app_with_storage" {
  source              = "./composite/function_app_with_storage"
  context             = local.context
  resource_group_name = module.resource_group.resource_group_name
  storage_accounts    = local.storage_accounts
  function_app_src    = local.function_app_src
}
