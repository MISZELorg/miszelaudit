location            = "northeurope"
resource_group_name = "rg-aztf-logging-prod-ne-01"
audit-logs_name     = "log-aztf-audit-logs-prod-ne-01"
audit-sa_name       = "miszelauditlogne01"
audit-kv_name       = "kv-aztf-log-prod-ne-02" # set to 01 once purged
audit-uami_name     = "uami-aztf-log-dev-ne-01"

rg_name     = "rg-aztf-logging-prod-ne-02"
kv_name     = "kv-aztf-log-prod-ne-03"
kv_sku_name = "standard"
kv_ip_rules = ["84.10.55.110/32"]