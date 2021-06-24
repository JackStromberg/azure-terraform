resource "azurerm_virtual_hub" "vwan_hub" {
    name                = "vhub-vwan-${var.location}-${var.unique_id}"
    location            = var.location
    resource_group_name = var.resource_group_name
    virtual_wan_id      = var.vwan_id
    address_prefix      = var.vwan_hub_address_space

    tags = var.tags
}

resource "azurerm_vpn_gateway" "hub_vpn_gateway" {
    name                = "vgw-vhub-vwan-${var.location}-${var.unique_id}"
    location            = var.location
    resource_group_name = var.resource_group_name
    virtual_hub_id      = azurerm_virtual_hub.vwan_hub.id

    tags = var.tags
}

resource "azurerm_express_route_gateway" "hub_er_gateway" {
    name                = "egw-vhub-vwan-${var.location}-${var.unique_id}"
    location            = var.location
    resource_group_name = var.resource_group_name
    virtual_hub_id      = azurerm_virtual_hub.vwan_hub.id
    scale_units         = 1

    tags = var.tags
}

resource "azurerm_virtual_hub_connection" "vhub_vnet_connection" {
    for_each = toset(var.vnet_ids)

    name                      = format("%s-to-vhub-vwan-%s-%s",element(split("/",each.value),length(split("/",each.value))-1),var.location,var.unique_id)
    virtual_hub_id            = azurerm_virtual_hub.vwan_hub.id
    remote_virtual_network_id = each.value
}

resource "azurerm_virtual_hub_route_table" "vhub_route_table" {
    name           = "customTable"
    virtual_hub_id = azurerm_virtual_hub.vwan_hub.id
    labels         = ["label1"]

    route {
        name              = "example-route"
        destinations_type = "CIDR"
        destinations      = ["10.0.0.0/16"]
        next_hop_type     = "ResourceId"
        next_hop          = azurerm_virtual_hub_connection.vhub_vnet_connection[var.vnet_ids[0]].id
    }

}