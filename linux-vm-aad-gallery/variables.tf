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

# update the group name, with members who can login the VM and sudo to root
variable "groups" {
  default = ["ops-admin-group"]
}

variable "size" {
  type     = string
  default  = "Standard_D2s_v3"
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

# you can put your company's tenant id here, in most case, it would be not changed.
variable "tenant_id" {
  default = ""
}
variable "secondary_subscription_id" {
  default = ""
}

variable "subnet_name" {}
variable "vnet_name" {}
variable "vnet_rg" {}

variable "image_name" {}
variable "gallery_name" {}
variable "gallery_rg" {}

# set auto_shutdown, useful for non-prod environment
variable "auto_shutdown" {
  description = "Flag to enable or disable auto shutdown"
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Additional tags to be added to the resource"
  type        = map(string)
  default = {
    Terraform = "true"
  }
}
