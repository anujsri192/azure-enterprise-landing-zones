/**
 * # Enterprise Azure Firewall Premium Module
 * 
 * Provisions an Azure Firewall Premium with:
 * - Zone-redundant Public IP (zones 1, 2, 3)
 * - Centralized Firewall Policy with IDPS & Threat Intelligence in Deny mode
 * - Dynamic network & application rule collection groups
 */

resource "azurerm_public_ip" "this" {
  name                = "pip-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_firewall_policy" "this" {
  name                     = "fwp-${var.name}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku_tier
  threat_intelligence_mode = var.threat_intel_mode
  tags                     = var.tags

  dynamic "intrusion_detection" {
    for_each = var.sku_tier == "Premium" ? [1] : []
    content {
      mode = "Deny"
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "fw-rcg-core-rules"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 500

  dynamic "network_rule_collection" {
    for_each = var.network_rule_collections
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = var.application_rule_collections
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name              = rule.value.name
          source_addresses  = rule.value.source_addresses
          destination_fqdns = rule.value.destination_fqdns

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              port = protocols.value.port
              type = protocols.value.type
            }
          }
        }
      }
    }
  }
}

resource "azurerm_firewall" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.this.id
  zones               = ["1", "2", "3"]
  tags                = var.tags

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.this.id
  }

  depends_on = [azurerm_firewall_policy_rule_collection_group.this]
}
