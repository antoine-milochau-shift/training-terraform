resource "azurerm_resource_group" "resource_group" {
  name     = "poc-terraform-${var.name_suffix}"
  location = "France Central"
}