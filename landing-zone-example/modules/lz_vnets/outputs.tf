output "hub_network" {
    value = azurerm_virtual_network.hub_network
    description = "Hub virtual network"
}

output "spoke_network" {
    value = azurerm_virtual_network.spoke_network
    description = "Spoke virtual network"
}

output "hub_subnetA" {
    value = azurerm_subnet.hub_subnetA
    description = "Hub subnet A"
}

output "hub_subnetB" {
    value = azurerm_subnet.hub_subnetB
    description = "Hub subnet B"
}

output "spoke_subnetA" {
    value = azurerm_subnet.spoke_subnetA
    description = "Spoke subnet A"
}

output "spoke_subnetB" {
    value = azurerm_subnet.spoke_subnetB
    description = "Spoke subnet B"
}