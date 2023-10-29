resource "random_id" "this" {
  byte_length = 2
}

locals {
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

resource "azurerm_resource_group" "this" {
  location = var.location
  name     = local.name
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

module "linux-vm-aad" {
  source = "git::https://github.com/Azure/terraform-azurerm-virtual-machine.git"

  location            = var.location
  image_os            = "linux"
  resource_group_name = local.name
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
  os_simple = var.os_simple
  size      = var.size
  subnet_id = data.azurerm_subnet.this.id
  extensions = [
    {
      name                 = "AADSSHLoginForLinux"
      publisher            = "Microsoft.Azure.ActiveDirectory",
      type                 = "AADSSHLoginForLinux",
      type_handler_version = "1.0"
    },
  ]

  depends_on = [
    "azurerm_resource_group.this"
  ]

}

resource "azurerm_role_assignment" "this" {
  principal_id         = data.azuread_groups.this.object_ids[0]
  role_definition_name = "Virtual Machine Administrator Login"
  scope                = azurerm_resource_group.this.id
}

