variable "project" {
  type     = string
  default  = "vm"
  nullable = false
}

variable "env" {
  type    = string
  default = "dev"
}

variable "location" {
  type     = string
  default  = "eastus"
  nullable = false
}

variable "groups" {
  default = ["ops-admin-group"]
}

variable "os_simple" {
  type    = string
  default = "RHEL"
}

variable "size" {
  type     = string
  default  = "Standard_F2"
  nullable = false
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(set(string))
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = null
  }
}

variable "subnet_name" {}
variable "vnet_name" {}
variable "vnet_rg" {}
