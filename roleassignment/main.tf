resource "azurerm_role_assignment" "RBAC-uami" {
  scope                = var.scope
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id
  principal_type       = var.principal_type
}