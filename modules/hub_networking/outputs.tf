output "vnet_id" {
  description = "The ID of the Hub VNet."
  value       = azurerm_virtual_network.hub.id
}

output "vnet_name" {
  description = "The name of the Hub VNet."
  value       = azurerm_virtual_network.hub.name
}

output "firewall_subnet_id" {
  description = "The ID of the AzureFirewallSubnet."
  value       = azurerm_subnet.firewall.id
}

output "gateway_subnet_id" {
  description = "The ID of the GatewaySubnet."
  value       = azurerm_subnet.gateway.id
}

output "bastion_subnet_id" {
  description = "The ID of the AzureBastionSubnet."
  value       = try(azurerm_subnet.bastion[0].id, null)
}

output "management_subnet_id" {
  description = "The ID of the Hub Management Subnet."
  value       = azurerm_subnet.management.id
}

