data "azurerm_user_assigned_identity" "uami-logs" {
  name                = var.uami_name
  resource_group_name = var.rg_name
  depends_on          = [azurerm_user_assigned_identity.uami]
}