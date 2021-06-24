output "nsg_spoke_subnetA" {
    value = azurerm_network_security_group.nsg_spoke_subnetA
    description = "SubnetA NSG associated to Spoke VNet"
}