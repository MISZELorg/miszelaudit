output "uami-logs_id" {
  value = data.azurerm_user_assigned_identity.uami-logs.principal_id
}