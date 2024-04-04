terraform {
  backend "azurerm" {
    resource_group_name  = "rg-githubtfstates"
    storage_account_name = "miszelidentity"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
    subscription_id      = "f80611eb-0851-4373-b7a3-f272906843c4"
    tenant_id            = var.tenant_id
  }
}