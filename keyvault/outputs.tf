output "tenantid" {
  value = data.azurerm_client_config.current.tenant_id
}

output "keyvault_id" {
  value = data.azurerm_key_vault.key_vault.id
}

output "key_name" {
  value = data.azurerm_key_vault_key.key1.id
}