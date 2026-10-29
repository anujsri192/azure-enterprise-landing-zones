/**
 * # Enterprise Cloud Adoption Framework (CAF) Management Group Hierarchy
 * 
 * Standard hierarchy implementing governance, compliance, and RBAC boundaries:
 * - Root Enterprise Group
 *   ├── Platform (Management, Connectivity, Identity)
 *   ├── Landing Zones (Corp, Online)
 *   ├── Sandboxes
 *   └── Decommissioned
 */

# Root Enterprise Management Group
resource "azurerm_management_group" "root" {
  display_name               = "${upper(var.prefix)} Enterprise Group"
  name                       = "${var.prefix}-root"
  parent_management_group_id = var.root_parent_management_group_id
}

# 1. Platform MG
resource "azurerm_management_group" "platform" {
  display_name               = "Platform"
  name                       = "${var.prefix}-platform"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "connectivity" {
  display_name               = "Connectivity"
  name                       = "${var.prefix}-platform-connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "management" {
  display_name               = "Management"
  name                       = "${var.prefix}-platform-management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "identity" {
  display_name               = "Identity"
  name                       = "${var.prefix}-platform-identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

# 2. Application Landing Zones MG
resource "azurerm_management_group" "landing_zones" {
  display_name               = "Landing Zones"
  name                       = "${var.prefix}-landing-zones"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "corp" {
  display_name               = "Corp (Private Routing)"
  name                       = "${var.prefix}-lz-corp"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "online" {
  display_name               = "Online (Public Ingress)"
  name                       = "${var.prefix}-lz-online"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

# 3. Sandboxes & Decommissioned
resource "azurerm_management_group" "sandbox" {
  display_name               = "Sandboxes"
  name                       = "${var.prefix}-sandbox"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "decommissioned" {
  display_name               = "Decommissioned"
  name                       = "${var.prefix}-decommissioned"
  parent_management_group_id = azurerm_management_group.root.id
}

