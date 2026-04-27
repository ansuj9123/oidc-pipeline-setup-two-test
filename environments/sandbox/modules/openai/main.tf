resource "azurerm_cognitive_account" "openai" {
  name                = "${var.project_name}-openai"
  location            = var.location
  resource_group_name = var.resource_group_name

  kind     = "OpenAI"
  sku_name = "S0"
}

resource "azurerm_cognitive_deployment" "model" {
  name                 = "gpt-4o-mini"
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "latest"
  }

  scale {
    type = "Standard"
  }
}