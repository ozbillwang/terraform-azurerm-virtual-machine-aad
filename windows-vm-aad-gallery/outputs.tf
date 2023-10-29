output "image_id" {
  value = data.azurerm_shared_image_version.this.id
}

output "vm_name" {
  value = module.vm-aad.vm_name
}
