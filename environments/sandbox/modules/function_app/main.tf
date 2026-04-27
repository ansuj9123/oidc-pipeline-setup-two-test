resource "azurerm_storage_account" "sa" {
  name                     = "${var.project_name}sa123"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_application_insights" "appi" {
  name                = "${var.project_name}-appi"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.project_name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name = "B1" # Basic plan to avoid Y1 quota issues
}

resource "azurerm_linux_function_app" "func" {
  name                       = "${var.project_name}-func"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appi.connection_string
    "OPENAI_ENDPOINT"                = var.openai_endpoint
  }
}