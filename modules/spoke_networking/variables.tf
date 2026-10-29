variable "resource_group_name" {
  description = "Resource group name for spoke networking."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "spoke_name" {
  description = "Name identifier for the Spoke (e.g. corp-workloads)."
  type        = string
}

variable "address_space" {
  description = "Address space for the Spoke VNet."
  type        = list(string)
  default     = ["10.101.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create within the spoke."
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
  }))
}

variable "hub_vnet_id" {
  description = "Resource ID of the Hub VNet for peering."
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the Hub VNet."
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group name where the Hub VNet resides."
  type        = string
}

variable "firewall_private_ip" {
  description = "Private IP of the Azure Firewall in the Hub for UDR next hop."
  type        = string
}

variable "tags" {
  description = "Tags applied to all spoke networking resources."
  type        = map(string)
  default     = {}
}

