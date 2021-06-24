resource "azurerm_route_table" "udr_spoke_subnetA" {
  name                = "udr-${var.location}-${var.unique_id}-subnetA-spoke"
  location            = var.location
  resource_group_name = var.resource_group_name
  disable_bgp_route_propagation = false

  tags = var.tags
}

resource "azurerm_route" "udr_spoke_subnetA_rule1" {
  name                = "rule1"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.udr_spoke_subnetA.name
  address_prefix      = "1.2.3.4/32"
  next_hop_type       = "None"
}

resource "azurerm_route" "udr_spoke_subnetA_rule2" {
  name                = "rule2"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.udr_spoke_subnetA.name
  address_prefix      = "4.3.2.1/32"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = "5.5.5.5"
}