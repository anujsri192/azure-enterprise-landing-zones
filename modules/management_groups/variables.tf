variable "root_parent_management_group_id" {
  description = "The parent ID of the Tenant Root Group (or null to use default)."
  type        = string
  default     = null
}

variable "prefix" {
  description = "Enterprise prefix for Management Groups."
  type        = string
  default     = "contoso"
}

