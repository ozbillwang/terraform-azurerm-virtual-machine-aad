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
  default = ["AnyCloud-Demo"]
}

variable "os_simple" {
  type    = string
  default = "RHEL"
}

variable "size" {
  type     = string
  default  = "Standard_DS1_v2"
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

variable "image_name" {}
variable "gallery_name" {}
variable "gallery_rg" {}

variable "subscription_secondary" {}
