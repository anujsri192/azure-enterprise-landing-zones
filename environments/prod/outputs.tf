output "management_groups_root_id" {
  description = "Resource ID of the Root Management Group."
  value       = module.management_groups.root_id
}

output "hub_vnet_id" {
  description = "The ID of the Hub VNet."
  value       = module.hub_networking.vnet_id
}

output "firewall_private_ip" {
  description = "The private IP address of the Azure Firewall."
  value       = module.azure_firewall.private_ip_address
}

output "spoke_vnet_id" {
  description = "The ID of the Spoke Workload VNet."
  value       = module.corp_spoke.vnet_id
}

output "spoke_route_table_id" {
  description = "The ID of the Spoke Route Table."
  value       = module.corp_spoke.route_table_id
}

