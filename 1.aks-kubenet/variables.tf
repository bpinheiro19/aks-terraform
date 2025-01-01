## Variables
variable "location" {
  type        = string
  default     = "swedencentral"
  description = "Location of the resource group."
}

## Resource groups
variable "rg" {
  type        = string
  default     = "tf-rg"
}

## AKS
variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "kubernetes_version" {
  type        = string
  description = "The version of kubernetes"
  default     = "1.30.6"
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  type        = string
  description = "The admin username."
  default     = "azureuser"
}