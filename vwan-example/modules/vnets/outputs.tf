output "spoke_network" {
    value = azurerm_virtual_network.spoke_network
    description = "Spoke virtual network"
}

output "spoke_subnetA" {
    value = azurerm_subnet.spoke_subnetA
    description = "Spoke subnet A"
}

output "spoke_subnetB" {
    value = azurerm_subnet.spoke_subnetB
    description = "Spoke subnet B"
}