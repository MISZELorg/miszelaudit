module "rg" {
  source   = "./rg"
  rg_name  = var.rg_name
  location = var.location
}

module "sa" {
  source         = "./sa"
  rg_name        = var.rg_name
  location       = var.location
  sa_name        = var.sa_name
  github_runners = var.github_runners
  keyvault_id    = module.keyvault.keyvault_id
  key_id         = module.keyvault.key_id
  uami_id        = module.uami.uami_id
  # key_name = module.keyvault.key_name
  depends_on = [
    module.rg,
    module.uami,
    module.keyvault
  ]
}

module "keyvault" {
  source         = "./keyvault"
  rg_name        = var.rg_name
  location       = var.location
  kv_name        = var.kv_name
  kv_sku_name    = var.kv_sku_name
  github_runners = var.github_runners

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
  ]
}

module "roleassignment-uami-kv" {
  source               = "./roleassignment"
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = module.uami.uami-logs_id
  principal_type       = "ServicePrincipal"
  depends_on = [
    module.rg,
    module.keyvault,
    module.uami
  ]
}

module "roleassignment-admin-kv" {
  source               = "./roleassignment"
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.admin
  principal_type       = "User"
  depends_on = [
    module.rg,
    module.keyvault,
    module.uami
  ]
}

module "roleassignment-spn-kv" {
  source               = "./roleassignment"
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.spn_admin
  principal_type       = "ServicePrincipal"
  depends_on = [
    module.rg,
    module.keyvault,
    module.uami
  ]
}

module "roleassignment-spn-kv2" {
  source               = "./roleassignment"
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Reader"
  principal_id         = var.spn_reader
  principal_type       = "ServicePrincipal"
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
  principal_id         = var.spn_admin
  principal_type       = "ServicePrincipal"
  depends_on = [
    module.rg,
    # module.sa,
    module.uami
  ]
}

module "roleassignment-spn-sa-2" {
  source               = "./roleassignment"
  scope                = module.sa.sa_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.spn_reader
  principal_type       = "ServicePrincipal"
  depends_on = [
    module.rg,
    # module.sa,
    module.uami
  ]
}

module "roleassignment-spn-sa-3" {
  source               = "./roleassignment"
  scope                = module.sa.sa_id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.admin
  principal_type       = "User"
  depends_on = [
    module.rg,
    # module.sa,
    module.uami
  ]
}

module "roleassignment-spn-sa-4" {
  source               = "./roleassignment"
  scope                = module.sa.sa_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.spn_reader
  principal_type       = "ServicePrincipal"
  depends_on = [
    module.rg,
    # module.sa,
    module.uami
  ]
}

module "roleassignment-spn-sa-5" {
  source               = "./roleassignment"
  scope                = module.sa.sa_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.spn_admin
  principal_type       = "ServicePrincipal"
  depends_on = [
    module.rg,
    # module.sa,
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