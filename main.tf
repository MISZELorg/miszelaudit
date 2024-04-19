module "rg" {
  source   = "./rg"
  rg_name  = var.rg_name
  location = var.location
}

module "sa" {
  source   = "./sa"
  rg_name  = var.rg_name
  location = var.location
  sa_name  = var.sa_name
  depends_on = [
    module.rg,
  ]
}

module "keyvault" {
  source      = "./keyvault"
  rg_name     = var.rg_name
  location    = var.location
  kv_name     = var.kv_name
  kv_sku_name = var.kv_sku_name
  kv_ip_rules = var.kv_ip_rules

  depends_on = [
    module.rg,
  ]
}

module "uami" {
  source    = "./uami"
  rg_name   = var.rg_name
  location  = var.location
  uami_name = var.uami_name
  depends_on = [
    module.rg,
    module.keyvault
  ]
}

module "roleassignment-uami-kv" {
  source               = "./roleassignment"
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = module.uami.uami-logs_id
  depends_on = [
    module.rg,
    module.keyvault,
    module.uami
  ]
}

module "roleassignment-spn-sa" {
  source               = "./roleassignment"
  scope                = module.sa.sa_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = "c45e89ca-8212-45e9-8b55-f26b6040f9aa"
  depends_on = [
    module.rg,
    module.keyvault,
    module.uami
  ]
}

module "roleassignment-spn-sa-2" {
  source               = "./roleassignment"
  scope                = module.sa.sa_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = "3ee74291-276c-4ffc-8475-52144540279c"
  depends_on = [
    module.rg,
    module.keyvault,
    module.uami
  ]
}

module "laws" {
  source    = "./laws"
  rg_name   = var.rg_name
  location  = var.location
  logs_name = var.logs_name
  depends_on = [
    module.rg,
    module.keyvault,
    module.uami
  ]
}

# resource "azurerm_storage_container" "cont-insights-activity-logs" {
#   name                  = "insights-activity-logs"
#   storage_account_name  = azurerm_storage_account.sa-audit-logs.name
#   container_access_type = "private"
#   depends_on = [
#     azurerm_resource_group.rg-audit,
#     azurerm_storage_account.sa-audit-logs,
#     azurerm_role_assignment.RBAC-AZTF-sa-audit-logs
#   ]
# }

# resource "azurerm_storage_container" "cont-insights-operational-logs" {
#   name                  = "insights-operational-logs"
#   storage_account_name  = azurerm_storage_account.sa-audit-logs.name
#   container_access_type = "private"
#   depends_on = [
#     azurerm_resource_group.rg-audit,
#     azurerm_storage_account.sa-audit-logs,
#     azurerm_role_assignment.RBAC-AZTF-sa-audit-logs
#   ]
# }