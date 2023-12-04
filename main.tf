resource "azurerm_resource_group" "resource_group" {
  name     = "test-resource-group"
  location = "France Central"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "teststorageaccount"
  location                 = "France Central"
  resource_group_name      = azurerm_resource_group.resource_group.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}