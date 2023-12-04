terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    azurerm = ">= 3.0, < 4.0"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  use_oidc                   = true
  storage_use_azuread        = true
}