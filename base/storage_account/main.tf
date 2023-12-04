resource "azurerm_storage_account" "storage_account" {
  name                     = "poc${var.name_suffix}"
  location                 = "France Central"
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  cross_tenant_replication_enabled = false
  enable_https_traffic_only        = true
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  shared_access_key_enabled        = false
  default_to_oauth_authentication  = true
  allowed_copy_scope               = "AAD"
}

resource "azurerm_storage_container" "containers" {
  for_each             = var.containers
  name                 = each.key
  storage_account_name = azurerm_storage_account.storage_account.name
}

// Grant permission to the current deployment user to the whole Storage Account

data "azuread_client_config" "current" {}
resource "azurerm_role_assignment" "data_owner" {
  principal_id         = data.azuread_client_config.current.object_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = azurerm_storage_account.storage_account.id
}