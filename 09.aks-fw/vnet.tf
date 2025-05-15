
# HUB vnet and subnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name 
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name 
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "aks_subnet_nsg" {
  name                = "aks_subnet_nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_subnet_nsg.id
}

resource "azurerm_subnet" "fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name 
  address_prefixes     = ["10.0.1.0/24"]
}

## Route table
resource "azurerm_route_table" "aks_route_table" {
  name                          = "aks_route_table"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name

  route {
    name           = "fw_rule"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  }

  route {
    name           = "fw_internet_rule"
    address_prefix = "${azurerm_public_ip.fw_ip.ip_address}/32"
    next_hop_type  = "Internet"
  }

  depends_on = [azurerm_public_ip.fw_ip]
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  subnet_id      = azurerm_subnet.aks_subnet.id
  route_table_id = azurerm_route_table.aks_route_table.id
}
