terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.8.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-githubtfstates"
    storage_account_name = "miszelaudit"
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

resource "azurerm_resource_group" "rg-audit" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa-audit-logs" {
  name                             = var.audit-sa_name
  resource_group_name              = azurerm_resource_group.rg-audit.name
  location                         = azurerm_resource_group.rg-audit.location
  account_tier                     = "Standard"
  account_replication_type         = "RAGRS"
  cross_tenant_replication_enabled = false
  allow_nested_items_to_be_public  = false
  depends_on                       = [azurerm_resource_group.rg-audit]

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = []
    ip_rules                   = []
  }

}

resource "azurerm_role_assignment" "RBAC-AZTF-sa-audit-logs" {
  scope                = azurerm_storage_account.sa-audit-logs.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = "c45e89ca-8212-45e9-8b55-f26b6040f9aa"
  depends_on           = [azurerm_storage_account.sa-audit-logs]
}

resource "azurerm_role_assignment" "RBAC-AZTFREAD-sa-audit-logs" {
  scope                = azurerm_storage_account.sa-audit-logs.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = "3ee74291-276c-4ffc-8475-52144540279c"
  depends_on           = [azurerm_storage_account.sa-audit-logs]
}

# resource "azurerm_storage_container" "cont-insights-activity-logs" {
#   name                  = "insights-activity-logs"
#   storage_account_name  = azurerm_storage_account.sa-audit-logs.name
#   container_access_type = "private"
#   depends_on = [
#     azurerm_resource_group.rg-audit,
#     azurerm_storage_account.sa-audit-logs,
#     azurerm_role_assignment.RBAC-AZTF-sa-audit-logs
#   ]
# }

# resource "azurerm_storage_container" "cont-insights-operational-logs" {
#   name                  = "insights-operational-logs"
#   storage_account_name  = azurerm_storage_account.sa-audit-logs.name
#   container_access_type = "private"
#   depends_on = [
#     azurerm_resource_group.rg-audit,
#     azurerm_storage_account.sa-audit-logs,
#     azurerm_role_assignment.RBAC-AZTF-sa-audit-logs
#   ]
# }

# # resource "azurerm_log_analytics_workspace" "log-audit-logs" {
# #   name                = var.audit-logs_name
# #   location            = azurerm_resource_group.rg-audit.location
# #   resource_group_name = azurerm_resource_group.rg-audit.name
# #   sku                 = "PerGB2018"
# #   retention_in_days   = 365
# #   depends_on          = [azurerm_resource_group.rg-audit]
# # }

# resource "azurerm_key_vault" "kv-audit-logs" {
#   name                            = var.audit-kv_name
#   location                        = azurerm_resource_group.rg-audit.location
#   resource_group_name             = azurerm_resource_group.rg-audit.name
#   sku_name                        = "standard"
#   tenant_id                       = data.azurerm_client_config.current.id #"48c383d8-47c5-48f9-9e8b-afe4f2519054"
#   enabled_for_deployment          = false
#   enabled_for_disk_encryption     = true
#   enabled_for_template_deployment = true
#   soft_delete_retention_days      = 90
#   purge_protection_enabled        = false # set to false once ready
#   enable_rbac_authorization       = true
#   public_network_access_enabled   = false
#   depends_on                      = [azurerm_resource_group.rg-audit]

#   network_acls {
#     bypass                     = "AzureServices"
#     default_action             = "Deny"
#     virtual_network_subnet_ids = []
#     ip_rules                   = ["84.10.55.110"]
#   }
# }

# # resource "azurerm_user_assigned_identity" "uami-audit-logs" {
# #   name                = var.audit-uami_name
# #   location            = azurerm_resource_group.rg-audit.location
# #   resource_group_name = azurerm_resource_group.rg-audit.name
# #   depends_on          = [azurerm_resource_group.rg-audit]
# # }