resource "azurerm_storage_account" "sa-logs" {
  name                             = var.sa_name
  resource_group_name              = var.rg_name
  location                         = var.location
  account_tier                     = "Standard"
  account_replication_type         = "RAGRS"
  cross_tenant_replication_enabled = false
  allow_nested_items_to_be_public  = false

  # identity {
  #   type = "SystemAssigned"
  # }

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }

  network_rules {
    default_action = "Deny"

    dynamic "ip_rule" {
      for_each = var.github_runners
      content {
        ip_address_or_range = ip_rule.value
      }
    }
  }

}

# resource "azurerm_storage_account_customer_managed_key" "cmk-logs" {
#   storage_account_id = azurerm_storage_account.sa-logs.id
#   key_vault_id       = var.keyvault_id
#   key_name           = var.key_name
#   # user_assigned_identity_id = var.uami_id

# }

resource "azurerm_storage_container" "cont-insights-activity-logs" {
  name                  = "insights-activity-logs"
  storage_account_name  = azurerm_storage_account.sa-logs.name
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.sa-logs,
  ]
}

resource "azurerm_storage_container" "cont-insights-operational-logs" {
  name                  = "insights-operational-logs"
  storage_account_name  = azurerm_storage_account.sa-logs.name
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.sa-logs,
  ]
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