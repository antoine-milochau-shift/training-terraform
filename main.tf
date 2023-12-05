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
  containers = {
    "content" = {}
  }
}

module "function_app" {
  source              = "./base/function_app"
  name_suffix         = random_string.name_suffix.result
  resource_group_name = module.resource_group.resource_group_name
  function_app_src    = "./src"
  extra_app_settings = {
    STORAGE_ACCOUNT_CONTENT_NAME = module.storage_account.storage_account_name
  }
}

// Grant permission to the Function App to the whole Storage Account

resource "azurerm_role_assignment" "data_owner" {
  principal_id         = module.function_app.function_app_principal_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = module.storage_account.storage_account_id
}