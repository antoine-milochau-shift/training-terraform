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

moved {
  from = azurerm_resource_group.resource_group
  to   = module.resource_group.azurerm_resource_group.resource_group
}

moved {
  from = azurerm_storage_account.storage_account
  to   = module.storage_account.azurerm_storage_account.storage_account
}