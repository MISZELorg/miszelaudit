output "uami-logs_id" {
  value = azurerm_user_assigned_identity.uami.principal_id
}

output "uami_id" {
  value = azurerm_user_assigned_identity.uami.id
}