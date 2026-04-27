terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"   # Create this manually once
    storage_account_name = "staidevopsstate123"  # Create this manually once (must be unique)
    container_name       = "tfstate"             # Create this container manually
    key                  = "sandbox.tfstate"
    use_oidc             = true                  # Uses the OIDC connection from your workflow
  }
}

provider "azurerm" {
  features {}
}