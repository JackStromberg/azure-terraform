output "name" {
    value = azurerm_virtual_machine.vm.name
    description = "VM Name"
}

output "id" {
    value = azurerm_virtual_machine.vm.id
    description = "VM ID"
}