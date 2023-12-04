resource "random_string" "name_suffix" {
  length  = 16
  special = false
  upper   = false
}

resource "azurerm_resource_group" "resource_group" {
  name     = "poc-terraform-${random_string.name_suffix.result}"
  location = "France Central"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "poc${random_string.name_suffix.result}"
  location                 = "France Central"
  resource_group_name      = azurerm_resource_group.resource_group.name
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