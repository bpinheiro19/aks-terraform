resource "random_string" "acr_suffix" {
  length  = 10
  special = false
  upper   = false
  numeric = false
}

## Create ACR
resource "azurerm_container_registry" "acr" {
  name                          = "acr${random_string.acr_suffix.result}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false
}

## Create ACR private DNS zone
resource "azurerm_private_dns_zone" "acr_zone" {
  name                = "privatelink.${var.location}.azurecr.io"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_vnet_link" {
  name                  = "aks-private-dns-zone-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

## Create ACR private endpoint
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "endpoint-${var.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "endpoint_private_service_connection-${var.suffix}"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.acr_zone.name
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_zone.id]
  }
}

data "azurerm_network_interface" "acr_pep_nic" {
  name                = azurerm_private_endpoint.acr_private_endpoint.network_interface[0].name
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [azurerm_private_endpoint.acr_private_endpoint]
}

resource "azurerm_private_dns_a_record" "acr_dns_record_data" {
  name                = lower(format("%s.%s.data", azurerm_container_registry.acr.name, azurerm_container_registry.acr.location))
  zone_name           = azurerm_private_dns_zone.acr_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  records             = [data.azurerm_network_interface.acr_pep_nic.private_ip_addresses[0]]
  depends_on = [data.azurerm_network_interface.acr_pep_nic]
}

resource "azurerm_private_dns_a_record" "acr_dns_record" {
  name                = lower(azurerm_container_registry.acr.name)
  zone_name           = azurerm_private_dns_zone.acr_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 3600
  records             = [data.azurerm_network_interface.acr_pep_nic.private_ip_addresses[1]]
  depends_on = [data.azurerm_network_interface.acr_pep_nic]
}
