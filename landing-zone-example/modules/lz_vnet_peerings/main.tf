locals {
  # Get vnet names from id
  source_vnet_name = element(split("/",var.source_vnet_id),length(split("/",var.source_vnet_id))-1)
  destination_vnet_name = element(split("/",var.destination_vnet_id),length(split("/",var.destination_vnet_id))-1)
}

resource "azurerm_virtual_network_peering" "peer1to2" {
  name                      = "${local.source_vnet_name}-to-${local.destination_vnet_name}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = local.source_vnet_name
  remote_virtual_network_id = var.destination_vnet_id
}

resource "azurerm_virtual_network_peering" "peer2to1" {
  name                      = "${local.destination_vnet_name}-to-${local.source_vnet_name}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = local.destination_vnet_name
  remote_virtual_network_id = var.source_vnet_id
}