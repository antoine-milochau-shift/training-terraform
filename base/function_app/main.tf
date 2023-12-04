// Publish Function App as a zipped file

resource "null_resource" "function_app_deployment" {
  provisioner "local-exec" {
    command     = "dotnet publish -c Release"
    working_dir = var.function_app_src
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

data "archive_file" "function_app_files" {
  type        = "zip"
  source_dir  = "${var.function_app_src}/bin/Release/net6.0/publish"
  output_path = "./output"
  depends_on  = [null_resource.function_app_deployment]
}

// Store the deployment package as a blob, in a dedicated container of a technical storage account used by the Function App

module "function_app_technical_storage_account" {
  source              = "../storage_account"
  name_suffix         = "${var.name_suffix}func"
  resource_group_name = var.resource_group_name
  containers = {
    "deployment" : {}
  }
}

resource "azurerm_storage_blob" "function_app_archive" {
  name                   = uuid()
  storage_account_name   = module.function_app_technical_storage_account.storage_account_name
  storage_container_name = "deployment"
  source                 = data.archive_file.function_app_files.output_path
  type                   = "Block"
  depends_on             = [module.function_app_technical_storage_account]
}

// Defines the Function App

resource "azurerm_service_plan" "service_plan" {
  name                = "poc-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = "France Central"
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "function_app" {
  name                          = "poc-${var.name_suffix}"
  resource_group_name           = var.resource_group_name
  location                      = "France Central"
  service_plan_id               = azurerm_service_plan.service_plan.id
  storage_account_name          = module.function_app_technical_storage_account.storage_account_name
  storage_uses_managed_identity = true
  https_only                    = true

  functions_extension_version = "~4"

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = azurerm_storage_blob.function_app_archive.url
  }

  site_config {
    ftps_state                       = "Disabled"
    http2_enabled                    = true
    minimum_tls_version              = "1.2"
    remote_debugging_enabled         = false
    runtime_scale_monitoring_enabled = false
    scm_minimum_tls_version          = "1.2"
    use_32_bit_worker                = false
    websockets_enabled               = false

    application_stack {
      dotnet_version              = "6.0"
      use_dotnet_isolated_runtime = true
    }

    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }
}

// Grant permission to the Function App to the whole Storage Account

resource "azurerm_role_assignment" "data_owner" {
  principal_id         = azurerm_linux_function_app.function_app.identity[0].principal_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = module.function_app_technical_storage_account.storage_account_id
}