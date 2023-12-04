resource "random_string" "name_suffix" {
  length  = 16
  special = false
  upper   = false
}

module "resource_group" {
  source      = "./base/resource_group"
  name_suffix = random_string.name_suffix.result
}

module "storage_account" {
  source              = "./base/storage_account"
  name_suffix         = random_string.name_suffix.result
  resource_group_name = module.resource_group.resource_group_name
}