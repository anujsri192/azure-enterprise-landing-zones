/**
 * # Production Enterprise Landing Zone Architecture (Parent Module)
 * 
 * Orchestrates:
 * 1. Microsoft Cloud Adoption Framework (CAF) Management Group Hierarchy
 * 2. Centralized Hub Network with AzureBastionSubnet, GatewaySubnet, and AzureFirewallSubnet
 * 3. Azure Firewall Premium with IDPS & Application/Network Rule Collections
 * 4. Spoke Workload Network with Forced Tunneling UDR (0.0.0.0/0 -> Firewall)
 * 5. Automated Bi-directional VNet Peering with Gateway Transit
 */

locals {
  name_prefix = "${var.prefix}-${var.environment}"
}

# --------------------------------------------------------------------------------------------------
# 1. Management Groups Hierarchy (CAF Governance)
# --------------------------------------------------------------------------------------------------
module "management_groups" {
  source = "../../modules/management_groups"

  prefix = var.prefix
}

# --------------------------------------------------------------------------------------------------
# 2. Resource Groups
# --------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "hub" {
  name     = "rg-${local.name_prefix}-hub"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "spoke" {
  name     = "rg-${local.name_prefix}-spoke-corp"
  location = var.location
  tags     = var.tags
}

# --------------------------------------------------------------------------------------------------
# 3. Hub Networking (Centralized Inspection Perimeter)
# --------------------------------------------------------------------------------------------------
module "hub_networking" {
  source = "../../modules/hub_networking"

  vnet_name                = "vnet-${local.name_prefix}-hub"
  resource_group_name      = azurerm_resource_group.hub.name
  location                 = azurerm_resource_group.hub.location
  address_space            = ["10.100.0.0/16"]
  firewall_subnet_prefix   = "10.100.1.0/26"
  gateway_subnet_prefix    = "10.100.2.0/27"
  bastion_subnet_prefix    = "10.100.3.0/26"
  management_subnet_prefix = "10.100.4.0/24"
  enable_bastion           = true
  tags                     = var.tags
}

# --------------------------------------------------------------------------------------------------
# 4. Azure Firewall Premium
# --------------------------------------------------------------------------------------------------
module "azure_firewall" {
  source = "../../modules/azure_firewall"

  name                = "afw-${local.name_prefix}-hub"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  subnet_id           = module.hub_networking.firewall_subnet_id
  sku_tier            = "Premium"
  threat_intel_mode   = "Deny"

  network_rule_collections = [
    {
      name     = "nrc-internal-management"
      priority = 100
      action   = "Allow"
      rules = [
        {
          name                  = "allow-ntp-and-dns"
          protocols             = ["UDP"]
          source_addresses      = ["10.101.0.0/16"]
          destination_addresses = ["*"]
          destination_ports     = ["53", "123"]
        }
      ]
    }
  ]

  application_rule_collections = [
    {
      name     = "arc-devsecops-registries"
      priority = 200
      action   = "Allow"
      rules = [
        {
          name             = "allow-github-and-package-managers"
          source_addresses = ["10.101.0.0/16"]
          destination_fqdns = [
            "github.com",
            "*.github.com",
            "*.githubusercontent.com",
            "registry.terraform.io",
            "pypi.org",
            "*.pypi.org"
          ]
          protocols = [
            {
              port = 443
              type = "Https"
            }
          ]
        }
      ]
    }
  ]

  tags = var.tags
}

# --------------------------------------------------------------------------------------------------
# 5. Spoke Workload Networking & Peering (Forced 0.0.0.0/0 Route to Firewall)
# --------------------------------------------------------------------------------------------------
module "corp_spoke" {
  source = "../../modules/spoke_networking"

  spoke_name              = "${local.name_prefix}-corp"
  resource_group_name     = azurerm_resource_group.spoke.name
  location                = azurerm_resource_group.spoke.location
  address_space           = ["10.101.0.0/16"]
  hub_vnet_id             = module.hub_networking.vnet_id
  hub_vnet_name           = module.hub_networking.vnet_name
  hub_resource_group_name = azurerm_resource_group.hub.name
  firewall_private_ip     = module.azure_firewall.private_ip_address

  subnets = {
    "snet-workloads-app" = {
      address_prefixes  = ["10.101.1.0/24"]
      service_endpoints = ["Microsoft.KeyVault"]
    }
    "snet-workloads-data" = {
      address_prefixes  = ["10.101.2.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
  }

  tags = var.tags

  depends_on = [module.azure_firewall]
}
