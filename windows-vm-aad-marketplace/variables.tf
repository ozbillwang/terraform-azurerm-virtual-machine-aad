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

# set Group here to allow VM login
variable "groups" {
  default = [""]
}

variable "os_simple" {
  type    = string
  default = "WindowsServer"
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

variable "admin_password" {
  default = ""
}

# set auto_shutdown, useful for non-prod environment
variable "auto_shutdown" {
  description = "Flag to enable or disable auto shutdown"
  type        = bool
  default     = true
}
