resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

## Create private AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.aks_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  dns_prefix              = random_pet.azurerm_kubernetes_cluster_dns_prefix.id
  private_cluster_enabled = true
  kubernetes_version      = var.kubernetes_version

   default_node_pool {
    name                 = "agentpool"
    node_count           = var.node_count
    vm_size              = var.vm_size
    vnet_subnet_id       = azurerm_subnet.subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "azure"
    dns_service_ip = "10.240.0.10"
    service_cidr   = "10.240.0.0/24"
    outbound_type  = "loadBalancer"
  }

}
