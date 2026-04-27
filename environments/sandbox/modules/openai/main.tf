resource "azurerm_cognitive_account" "openai" {
  name                = "${var.project_name}-openai"
  location            = var.location
  resource_group_name = var.resource_group_name

  kind     = "OpenAI"
  sku_name = "S0"
  restore_with_account_name = true # Attempt to restore if soft-deleted
}

resource "azurerm_cognitive_deployment" "model" {
  name                 = "gpt-4o-mini"
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "2024-07-18"
  }

  scale {
    type = "Standard"
  }
}