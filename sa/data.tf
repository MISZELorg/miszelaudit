# data "azurerm_storage_account" "sa-logs-id" {
#   name                = var.sa_name
#   resource_group_name = var.rg_name
#   depends_on          = [azurerm_storage_account.sa-logs]
# }