variable "location" {}
variable "resource_group_name" {}
variable "audit-logs_name" {}
variable "audit-sa_name" {}
variable "audit-kv_name" {}
variable "audit-uami_name" {}
variable "kvname" {}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}