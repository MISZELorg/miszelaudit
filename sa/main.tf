resource "azurerm_storage_account" "sa-logs" {
  name                             = var.sa_name
  resource_group_name              = var.rg_name
  location                         = var.location
  account_tier                     = "Standard"
  account_replication_type         = "RAGRS"
  cross_tenant_replication_enabled = false
  allow_nested_items_to_be_public  = false

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = []
    ip_rules                   = []
  }

}

resource "azurerm_storage_management_policy" "sa-logs-mgmt-policy" {
  storage_account_id = azurerm_storage_account.sa-logs.id

  rule {
    name    = "AuditLogsRule"
    enabled = true
    filters {
      prefix_match = []
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 2555
      }
    }
  }
}