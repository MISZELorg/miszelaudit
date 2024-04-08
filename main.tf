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

resource "azurerm_log_analytics_workspace" "log-audit-logs" {
  name                = var.audit-logs_name
  location            = azurerm_resource_group.rg-audit.location
  resource_group_name = azurerm_resource_group.rg-audit.name
  sku                 = "PerGB2018"
  retention_in_days   = 365
  depends_on          = [azurerm_resource_group.rg-audit]
}

resource "azurerm_storage_account" "sa-audit-logs" {
  name                     = var.audit-sa_name
  resource_group_name      = azurerm_resource_group.rg-audit.name
  location                 = azurerm_resource_group.rg-audit.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  depends_on               = [azurerm_resource_group.rg-audit]

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = []
    ip_rules                   = []
  }
}

resource "azurerm_key_vault" "kv-audit-logs" {
  name                            = var.audit-kv_name
  location                        = azurerm_resource_group.rg-audit.location
  resource_group_name             = azurerm_resource_group.rg-audit.name
  sku_name                        = "standard"
  tenant_id                       = "48c383d8-47c5-48f9-9e8b-afe4f2519054"
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  soft_delete_retention_days      = 7
  purge_protection_enabled        = true
  enable_rbac_authorization       = true
  public_network_access_enabled   = false
  depends_on                      = [azurerm_resource_group.rg-audit]

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = []
    ip_rules                   = []
  }
}

resource "azurerm_user_assigned_identity" "uami-audit-logs" {
  name                = var.audit-uami_name
  location            = azurerm_resource_group.rg-audit.location
  resource_group_name = azurerm_resource_group.rg-audit.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  depends_on          = [azurerm_resource_group.rg-audit]
}