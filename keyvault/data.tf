data "azurerm_client_config" "current" {}
# data "azurerm_key_vault" "key_vault" {
#   name                = var.kv_name
#   resource_group_name = var.rg_name
#   depends_on          = [azurerm_key_vault.key_vault]
# }

# data "azurerm_key_vault_key" "key1" {
#   name         = azurerm_key_vault_key.key1.name
#   key_vault_id = azurerm_key_vault.key_vault.id
# }