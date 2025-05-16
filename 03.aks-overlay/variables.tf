## Variables
variable "location" {
  type        = string
  default     = "swedencentral"
  description = "Location of the resource group."
}

## Resource groups
variable "rg_name" {
  type        = string
  default     = "aks-overlay-rg"
}

## VNETS
variable "vnet_name" {
  type        = string
  default     = "vnet"
}

## AKS
variable "aks_name" {
  type        = string
  default     = "aks-overlay"
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "kubernetes_version" {
  type        = string
  description = "The version of kubernetes"
  default     = "1.31.7"
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_D2ps_v6"
}
