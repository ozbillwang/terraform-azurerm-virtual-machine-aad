# Terraform Azure RM Virtual Machine Module
# https://github.com/Azure/terraform-azurerm-virtual-machine
# https://registry.terraform.io/modules/Azure/virtual-machine/azurerm/latest

resource "random_id" "this" {
  byte_length = 2
}

locals {
  # The windows VM name can be a maximum of 15 characters in length.
  # https://learn.microsoft.com/en-us/azure/virtual-machines/windows/faq#are-there-any-computer-name-requirements-
  name = "${var.project}-${var.env}-${random_id.this.hex}"
}

data "azurerm_subnet" "this" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

data "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}

data "azuread_groups" "this" {
  display_names = var.groups
}

data "template_file" "this" {
  template = file("templates/azure-user-data.ps1")
}

resource "azurerm_resource_group" "this" {
  location = var.location
  name     = local.name

  tags = {
    "terraform"           = "true"
    "env"                 = var.env
    "project"             = var.project
    "ccoe:default:app-ci" = local.name
  }

}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

module "vm-aad" {
  source = "git::https://github.com/Azure/terraform-azurerm-virtual-machine.git"

  location            = azurerm_resource_group.this.location
  image_os            = "windows"
  resource_group_name = azurerm_resource_group.this.name
  #checkov:skip=CKV_AZURE_50:Demo for extension
  allow_extension_operations = true
  boot_diagnostics           = false

  identity = var.identity

  new_network_interface = {
    ip_forwarding_enabled = false
    ip_configurations = [
      {
        primary = true
      }
    ]
  }
  admin_username = "azureuser"
  admin_password = var.admin_password
  admin_ssh_keys = [
    {
      public_key = tls_private_key.this.public_key_openssh
    }
  ]
  name = local.name
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  os_simple   = var.os_simple
  custom_data = base64encode(data.template_file.this.rendered)

  size      = var.size
  subnet_id = data.azurerm_subnet.this.id
  extensions = [
    {
      name                 = "AADLoginForWindows"
      publisher            = "Microsoft.Azure.ActiveDirectory",
      type                 = "AADLoginForWindows",
      type_handler_version = "2.1"
    },
  ]

}

resource "azurerm_role_assignment" "this" {
  principal_id         = data.azuread_groups.this.object_ids[0]
  role_definition_name = "Virtual Machine Administrator Login"
  scope                = azurerm_resource_group.this.id
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "this" {
  count              = var.auto_shutdown ? 1 : 0
  virtual_machine_id = module.vm-aad.vm_id
  location           = azurerm_resource_group.this.location
  enabled            = true

  daily_recurrence_time = "1900"
  timezone              = "AUS Eastern Standard Time"

  notification_settings {
    enabled = false
  }
}
