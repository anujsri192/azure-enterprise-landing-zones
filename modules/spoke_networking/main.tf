/**
 * # Enterprise Spoke Networking & Route Table Module
 * 
 * Provisions Spoke VNets with:
 * - Subnets mapped via for_each
 * - User-Defined Route (UDR) forcing all 0.0.0.0/0 traffic through the Hub Firewall
 * - Bi-directional VNet Peering to Hub VNet
 */

resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-${var.spoke_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

# --------------------------------------------------------------------------------------------------
# Route Table (Forced Tunneling via Hub Azure Firewall)
# --------------------------------------------------------------------------------------------------
resource "azurerm_route_table" "spoke_udr" {
  name                          = "rt-${var.spoke_name}-to-hub"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true
  tags                          = var.tags

  route {
    name                   = "route-all-to-azure-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

# --------------------------------------------------------------------------------------------------
# Subnets & Associations
# --------------------------------------------------------------------------------------------------
resource "azurerm_subnet" "spoke_subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}

resource "azurerm_subnet_route_table_association" "spoke_assoc" {
  for_each = var.subnets

  subnet_id      = azurerm_subnet.spoke_subnets[each.key].id
  route_table_id = azurerm_route_table.spoke_udr.id
}

# --------------------------------------------------------------------------------------------------
# Bi-Directional VNet Peering
# --------------------------------------------------------------------------------------------------
# Spoke -> Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "peer-${var.spoke_name}-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# Hub -> Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-hub-to-${var.spoke_name}"
  resource_group_name          = var.hub_resource_group_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}
