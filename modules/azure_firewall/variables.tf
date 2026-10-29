variable "name" {
  description = "Name of the Azure Firewall."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "sku_name" {
  description = "SKU name of the Azure Firewall. AZFW_VNet or AZFW_Hub."
  type        = string
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  description = "SKU tier of the Azure Firewall. Standard or Premium."
  type        = string
  default     = "Premium"
}

variable "subnet_id" {
  description = "The Resource ID of the AzureFirewallSubnet."
  type        = string
}

variable "threat_intel_mode" {
  description = "The operation mode for Threat Intelligence. Off, Alert, Deny."
  type        = string
  default     = "Deny"
}

variable "network_rule_collections" {
  description = "List of network rule collections to apply via firewall policy."
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name                  = string
      protocols             = list(string)
      source_addresses      = list(string)
      destination_addresses = list(string)
      destination_ports     = list(string)
    }))
  }))
  default = []
}

variable "application_rule_collections" {
  description = "List of application rule collections to apply via firewall policy."
  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name              = string
      source_addresses  = list(string)
      destination_fqdns = list(string)
      protocols = list(object({
        port = number
        type = string
      }))
    }))
  }))
  default = []
}

variable "tags" {
  description = "Tags applied to all firewall resources."
  type        = map(string)
  default     = {}
}

