resource "azurerm_key_vault" "key_vault" {
  name                            = var.kv_name
  location                        = var.location
  resource_group_name             = var.rg_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = false
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  soft_delete_retention_days      = 90
  purge_protection_enabled        = true
  sku_name                        = var.kv_sku_name
  public_network_access_enabled   = true

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = []
    ip_rules                   = var.github_runners
  }

}

resource "azurerm_key_vault_key" "key1" {
  name         = "kv-aztf-log-prod-ne-001-kek"
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}

resource "random_password" "username" {
  length           = 14
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "username" {
  name         = "setupadmin-username"
  value        = random_password.username.result
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "random_password" "password" {
  length  = 20
  special = false
}

resource "azurerm_key_vault_secret" "password" {
  name         = "setupadmin-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.key_vault.id
}