output "root_id" {
  description = "The ID of the Root Management Group."
  value       = azurerm_management_group.root.id
}

output "platform_id" {
  description = "The ID of the Platform Management Group."
  value       = azurerm_management_group.platform.id
}

output "landing_zones_id" {
  description = "The ID of the Landing Zones Management Group."
  value       = azurerm_management_group.landing_zones.id
}

output "corp_id" {
  description = "The ID of the Corp Management Group."
  value       = azurerm_management_group.corp.id
}

output "online_id" {
  description = "The ID of the Online Management Group."
  value       = azurerm_management_group.online.id
}

