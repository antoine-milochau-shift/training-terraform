module "storage_accounts" {
  for_each = var.storage_accounts
  source   = "../../base/storage_account"
  context = merge(var.context, {
    instance = each.key
  })
  resource_group_name = var.resource_group_name
  containers          = each.value.containers
}

module "function_app" {
  source = "../../base/function_app"
  context = merge(var.context, {
    instance = "0"
  })
  resource_group_name = var.resource_group_name
  function_app_src    = var.function_app_src
  extra_app_settings = {
    for k, v in var.storage_accounts : "STORAGE_ACCOUNT__${k}" => module.storage_accounts[k].storage_account_name
  }
}

// Grant permission to the Function App to the whole Storage Account

resource "azurerm_role_assignment" "data_owner" {
  for_each             = var.storage_accounts
  principal_id         = module.function_app.function_app_principal_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = module.storage_accounts[each.key].storage_account_id
}