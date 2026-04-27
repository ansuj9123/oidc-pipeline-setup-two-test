resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "openai" {
  source              = "./modules/openai"
  project_name        = var.project_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "function_app" {
  source              = "./modules/function_app"
  project_name        = var.project_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  openai_endpoint     = module.openai.endpoint
}

resource "azurerm_role_assignment" "openai_access" {
  scope                = module.openai.openai_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = module.function_app.principal_id
}