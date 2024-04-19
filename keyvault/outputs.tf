output "tenantid" {
  value = data.azurerm_client_config.current.tenant_id
}

output "keyvault_id" {
  value = data.azurerm_key_vault.key_vault.id
}