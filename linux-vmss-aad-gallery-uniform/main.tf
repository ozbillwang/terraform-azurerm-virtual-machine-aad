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

data "azurerm_shared_image_version" "this" {
  provider            = azurerm.secondary
  name                = "latest"
  image_name          = var.image_name
  gallery_name        = var.gallery_name
  resource_group_name = var.gallery_rg
}

resource "azurerm_resource_group" "this" {
  location = var.location
  name     = local.name

  tags = {
    "ccoe:default:app-ci" = local.name
  }

}

resource "azurerm_role_assignment" "this" {
  principal_id         = data.azuread_groups.this.object_ids[0]
  role_definition_name = "Virtual Machine Administrator Login"
  scope                = azurerm_resource_group.this.id
}


resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = "${local.name}-vmss"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.size
  instances           = 1

  admin_username = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.this.public_key_openssh
  }

  source_image_id = data.azurerm_shared_image_version.this.id

  identity {
    type = "SystemAssigned"
  }

  network_interface {
    name    = local.name
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = data.azurerm_subnet.this.id
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  extension {
    name                 = "AADSSHLoginForLinux"
    publisher            = "Microsoft.Azure.ActiveDirectory"
    type                 = "AADSSHLoginForLinux"
    type_handler_version = "1.0"

    settings = jsonencode({
      "commandToExecute" = "echo $HOSTNAME"
    })

    protected_settings = jsonencode({
      "managedIdentity" = {}
    })
  }
}
