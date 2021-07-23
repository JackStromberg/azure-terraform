resource "azurerm_virtual_network" "spoke_network" {
    name                = "vnet-${var.location}-${var.unique_id}-spoke"
    address_space       = ["10.${var.vnet_address_octect}.0.0/16"]
    location            = var.location
    resource_group_name = var.resource_group_name

    dns_servers = ["1.1.1.1","1.0.0.1"]

    tags = var.tags
}

resource "azurerm_subnet" "spoke_subnetA" {
  name                 = "subnetA"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_network.name
  address_prefixes     = ["10.${var.vnet_address_octect}.0.0/24"]
}

resource "azurerm_subnet" "spoke_subnetB" {
  name                 = "subnetB"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_network.name
  address_prefixes     = ["10.${var.vnet_address_octect}.1.0/24"]
}