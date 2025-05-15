
resource "azurerm_public_ip" "fw_ip" {
  name                = "firewall_public_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones
}

resource "azurerm_firewall" "firewall" {
  name                = "firewall"            
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  zones               = var.zones
  threat_intel_mode   = var.threat_intel_mode
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.policy.id


  ip_configuration {
    name                 = "fw_ip_config"
    subnet_id            = azurerm_subnet.fw_subnet.id
    public_ip_address_id = azurerm_public_ip.fw_ip.id
  }

  lifecycle {
    ignore_changes = [
      tags,

    ]
  }
}

resource "azurerm_firewall_policy" "policy" {
  name                = "fw_policy"   
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "policy" {
  name               = "fw_policy_rule_collection_group"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 500

  application_rule_collection {
    name     = "ApplicationRules"
    priority = 500
    action   = "Allow"

    rule {
      name             = "AllowMicrosoftFqdns"
      source_addresses = ["*"]

      destination_fqdns = [
        "*.cdn.mscr.io",
        "mcr.microsoft.com",
        "*.data.mcr.microsoft.com",
        "management.azure.com",
        "login.microsoftonline.com",
        "acs-mirror.azureedge.net",
        "dc.services.visualstudio.com",
        "*.opinsights.azure.com",
        "*.oms.opinsights.azure.com",
        "*.microsoftonline.com",
        "*.monitoring.azure.com",
      ]

      protocols {
        port = "80"
        type = "Http"
      }

      protocols {
        port = "443"
        type = "Https"
      }
    }

    rule {
      name             = "AllowFqdnsForOsUpdates"
      source_addresses = ["*"]

      destination_fqdns = [
        "security.ubuntu.com",
        "packages.microsoft.com"
      ]

      protocols {
        port = "80"
        type = "Http"
      }

      protocols {
        port = "443"
        type = "Https"
      }
    }
    
    rule {
      name             = "AllowImagesFqdns"
      source_addresses = ["*"]

      destination_fqdns = [
        "auth.docker.io",
        "registry-1.docker.io",
        "production.cloudflare.docker.com"
      ]

      protocols {
        port = "80"
        type = "Http"
      }

      protocols {
        port = "443"
        type = "Https"
      }
    }

  }

  network_rule_collection {
    name     = "NetworkRules"
    priority = 400
    action   = "Allow"

    rule {
      name                  = "DNS"
      source_addresses      = ["*"]
      destination_ports     = ["53"]
      destination_addresses = ["*"]
      protocols             = ["UDP"]
    }

    rule {
      name                  = "ServiceTags"
      source_addresses      = ["*"]
      destination_ports     = ["*"]
      destination_addresses = [
        "AzureContainerRegistry",
        "MicrosoftContainerRegistry",
        "AzureActiveDirectory"
      ]
      protocols             = ["Any"]
    }

    rule {
      name                  = "Internet"
      source_addresses      = ["*"]
      destination_ports     = ["*"]
      destination_addresses = ["*"]
      protocols             = ["TCP"]
    }
  }

  lifecycle {
    ignore_changes = [
      application_rule_collection,
      network_rule_collection,
      nat_rule_collection
    ]
  }
}
