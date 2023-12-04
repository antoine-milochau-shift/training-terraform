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