data "azurerm_user_assigned_identity" "uami-audit-logs" {
  name                = var.audit-uami_name
  resource_group_name = var.azurerm_resource_group.rg-audit.name
}