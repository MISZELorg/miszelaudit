data "azurerm_resource_group" "rg" {
  name = var.rg_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}