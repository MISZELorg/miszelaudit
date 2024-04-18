resource "azurerm_key_vault" "key_vault" {
  name                            = var.kv_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = false
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  soft_delete_retention_days      = 90
  purge_protection_enabled        = false #change to true once ready
  sku_name                        = var.kv_sku_name
  public_network_access_enabled   = false
  depends_on = [
    azurerm_resource_group.rg-audit,
  ]

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = []
    ip_rules                   = var.kv_ip_rules
  }

}