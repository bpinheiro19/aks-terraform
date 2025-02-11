## Variables
variable "location" {
  type        = string
  default     = "swedencentral"
  description = "Location of the resource group."
}

## Resource groups
variable "rg" {
  type        = string
  default     = "aks-appgw-rg"
}

## VNETS
variable "vnet_name" {
  type        = string
  default     = "vnet-aks-appgw"
}

## AKS
variable "aks_name" {
  type        = string
  default     = "aks-appgw"
}

variable "kubernetes_version" {
  type        = string
  description = "The version of kubernetes"
  default     = "1.30.7"
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_D2s_v3"
}
