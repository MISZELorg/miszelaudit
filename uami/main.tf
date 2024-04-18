resource "azurerm_user_assigned_identity" "uami" {
  name                = var.uami_name
  location            = var.location
  resource_group_name = var.rg_name
}