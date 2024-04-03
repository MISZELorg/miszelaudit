terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.8.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-githubtfstates"
    storage_account_name = "${{ secrets.AZURE_SA_NAME }}"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
    subscription_id      = "${{ secrets.AZURE_BACKEND_SUB_ID }}"
    tenant_id            = "${{ secrets.AZURE_TENANT_ID }}"
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# resource "azurerm_resource_group" "rg-aks" {
#   name     = var.resource_group_name
#   location = var.location
# }
