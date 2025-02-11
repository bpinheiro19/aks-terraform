## Create private AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.aks_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  dns_prefix              = "aks-appgw-dns"
  kubernetes_version      = var.kubernetes_version

   default_node_pool {
    name                 = "agentpool"
    node_count           = var.node_count
    vm_size              = var.vm_size
    vnet_subnet_id       = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.uami.id ] 
  }

  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.application_gateway.id
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "azure"
    dns_service_ip = "10.240.0.10"
    service_cidr   = "10.240.0.0/24"
    outbound_type  = "loadBalancer"
  }

  depends_on = [
    azurerm_role_assignment.vnet_aks_network_contributor
  ]

}