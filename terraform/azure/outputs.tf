output "public_ip" {
  value = azurerm_public_ip.p20.ip_address
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.p20.id
}