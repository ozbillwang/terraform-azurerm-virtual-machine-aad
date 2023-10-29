# terraform-azurerm-virtual-machine-aad

This repository is designed for my blogs

* [Login to a Virtual Machine using Azure AD Account on Linux](https://medium.com/@ozbillwang/login-to-a-virtual-machine-using-azure-ad-account-on-linux-e595894739cb)
* [[Terraform] Deploy Azure Virtual Machine with AAD enabled](https://medium.com/@ozbillwang/terraform-deploy-azure-virtual-machine-with-aad-enabled-69c1fb137d28)
* [AzureAD support for Azure VMSS (virtual machine scale set)](https://towardsdev.com/azuread-support-for-azure-vmss-virtual-machine-scale-set-73fd30163aaa)
* [Azure Centralized Bastion Solution](https://medium.com/@ozbillwang/azure-centralized-bastion-solution-7824b458013d)
* [Configure Local Group Policy to Disable NLA in Windows Server 2019 for AzureAD-Ready Logins.](https://medium.com/@ozbillwang/configure-local-group-policy-to-disable-nla-in-windows-server-2019-for-azuread-ready-logins-c67a8042c530)

# Quick Guide

### Prerequsite

* [Installed terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* The virtual network is prepared. I suggest not managing the VNet alongside VM/MVSS; they should be kept separate
* It's advisable to manage groups rather than individual users when assigning the `Virtual Machine Administrator Login` role to the VM

### Usage

This repository can be used as module, but a quick way is to clone it directly, cd to the sub-folder, update the `dev.tfvars` file, and your details in `deploy-dev.sh`. Then the change is ready to be deployed.

```
git clone https://github.com/ozbillwang/terraform-azurerm-virtual-machine-aad.git
cd terraform-azurerm-virtual-machine-aad

# for example, I'd like to create a VM , image from marketplace, with AAD login
cd linux-vm-aad-marketplace

# update `dev.tfvars` and `deploy-dev.sh`
./deploy-dev.sh

# if everything works fine,
terraform apply planfile
```
### terraform example codes to create virtual machine with AAD enabled

* [linux-vm-aad-gallery](linux-vm-aad-gallery)
  - create virtual machine
  - allow AAD login
  - source image from **Azure computer gallery**.
* [linux-vm-aad-marketplace](linux-vm-aad-marketplace)
  - create virtual machine
  - allow AAD login
  - source image from **Azure Marketplace**.
* [linux-vmss-aad-gallery-Uniform](linux-vm-aad-gallery-Uniform)
  - create virtual machine scale sets
  - its virtual machines / instances can be login with AAD
  - **Uniform** orchestration mode
  - source image from Azure computer gallery.
* [linux-vmss-aad-marketplace-Uniform](linux-vm-aad-marketplace-Uniform)
  - create virtual machine scale sets
  - its virtual machines / instances can be login with AAD
  - **Uniform** orchestration mode
  - source image from azure marketplace.
* [linux-vmss-aad-gallery-Flexible](linux-vm-aad-gallery-Flexible)
  - create virtual machine scale sets
  - its virtual machines / instances can be login with AAD
  - **Flexible** orchestration mode
  - source image from Azure computer gallery.
* [linux-vmss-aad-marketplace-flexible](linux-vmss-aad-marketplace-flexible)
  - create virtual machine scale sets
  - its virtual machines / instances can be login with AAD
  - **Flexible** orchestration mode
  - source image from azure marketplace.
* [windows-vm-aad-gallery](windows-vm-aad-gallery)
  - create virtual machine
  - allow AAD login
  - source image from Azure computer gallery.
* [windows-vm-aad-marketplace](windows-vm-aad-marketplace)
  - create virtual machine
  - allow AAD login
  - source image from Azure Marketplace
  - Need extra task to run command, check its [README](windows-vm-aad-marketplace/README.md)

### Reference

[Orchestration modes for Virtual Machine Scale Sets in Azure](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes)



