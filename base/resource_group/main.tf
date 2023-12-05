module "resource_naming" {
  source  = "git::https://github.com/shift-technology/tf-modules-azure.git//base/conventions/resource_naming?ref=v1"
  context = var.context
}

module "referential" {
  source = "git::https://github.com/shift-technology/tf-modules-azure.git//base/conventions/referential?ref=v1"
}

resource "azurerm_resource_group" "resource_group" {
  name     = module.resource_naming.naming.resourcegroup_name
  location = module.referential.locations[var.context.region]
  tags     = module.resource_naming.common_tags
}