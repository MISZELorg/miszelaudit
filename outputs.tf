output "uami-audit-logs_id" {
  value = data.azurerm_user_assigned_identity.uami-audit-logs.principal_id
}