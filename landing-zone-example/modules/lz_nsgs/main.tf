resource "azurerm_network_security_group" "nsg_spoke_subnetA" {
  name                =  "nsg-${var.location}-${var.unique_id}-subnetA-spoke"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "nsg_spoke_subnetA-ibound-rule-1" {
  name                        = "test123"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke_subnetA.name
}

resource "azurerm_network_security_rule" "nsg_spoke_subnetA-ibound-rule-2" {
  name                        = "test1234"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke_subnetA.name
}