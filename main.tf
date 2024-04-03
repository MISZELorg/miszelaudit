terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.8.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-githubtfstates"
    storage_account_name = "miszelsandbox"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
    subscription_id      = "f80611eb-0851-4373-b7a3-f272906843c4"
    tenant_id            = "48c383d8-47c5-48f9-9e8b-afe4f2519054"
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# # Define any Azure resources to be created here. A simple resource group is shown here as a minimal example.
# resource "azurerm_resource_group" "rg-aks" {
#   name     = var.resource_group_name
#   location = var.location
# }
