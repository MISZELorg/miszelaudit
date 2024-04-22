data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "key_vault" {
  name                = var.kv_name
  resource_group_name = var.rg_name
  depends_on          = [azurerm_key_vault.key_vault]
}

data "azurerm_key_vault_key" "key1" {
  name         = "kv-aztf-log-prod-ne-001-kek"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}