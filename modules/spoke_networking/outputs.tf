output "vnet_id" {
  description = "The ID of the Spoke VNet."
  value       = azurerm_virtual_network.spoke.id
}

output "vnet_name" {
  description = "The name of the Spoke VNet."
  value       = azurerm_virtual_network.spoke.name
}

output "subnet_ids" {
  description = "Map of Spoke subnet names to their IDs."
  value       = { for k, v in azurerm_subnet.spoke_subnets : k => v.id }
}

output "route_table_id" {
  description = "The ID of the Spoke Route Table."
  value       = azurerm_route_table.spoke_udr.id
}

