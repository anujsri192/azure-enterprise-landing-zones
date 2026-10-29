variable "resource_group_name" {
  description = "Resource group name for hub networking."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "vnet_name" {
  description = "Name of the Hub Virtual Network."
  type        = string
}

variable "address_space" {
  description = "CIDR range for Hub VNet."
  type        = list(string)
  default     = ["10.100.0.0/16"]
}

variable "firewall_subnet_prefix" {
  description = "CIDR prefix for AzureFirewallSubnet (minimum /26)."
  type        = string
  default     = "10.100.1.0/26"
}

variable "gateway_subnet_prefix" {
  description = "CIDR prefix for GatewaySubnet (minimum /27)."
  type        = string
  default     = "10.100.2.0/27"
}

variable "bastion_subnet_prefix" {
  description = "CIDR prefix for AzureBastionSubnet (minimum /26)."
  type        = string
  default     = "10.100.3.0/26"
}

variable "management_subnet_prefix" {
  description = "CIDR prefix for Management Subnet."
  type        = string
  default     = "10.100.4.0/24"
}

variable "enable_bastion" {
  description = "Whether to deploy Azure Bastion Host."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to all hub networking resources."
  type        = map(string)
  default     = {}
}

