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

resource "azurerm_vpn_site" "hub_vpn_gateway_onsite1" {
    name                = "site-vpn-vhub-vwan-${var.location}-${var.unique_id}-OnSite1"
    location            = var.location
    resource_group_name = var.resource_group_name
    virtual_wan_id      = var.vwan_id

    address_cidrs       = ["10.${var.onprem_address_second_octect}.${var.onprem_address_third_octect}.0/24","10.${var.onprem_address_second_octect}.${var.onprem_address_third_octect2}.0/24"]
    device_model        = var.OnSite-GW-Model
    device_vendor       = var.OnSite-GW-Vendor

    link {
        name            = "site-vpn-vhub-vwan-${var.location}-${var.unique_id}-OnSite1"
        ip_address      = var.SiteLinkPublicIP
        speed_in_mbps   = 100
        provider_name   = "Generic ISP Co"
    }

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
    count = length(var.vnet_ids)

    name                      = format("%s-to-vhub-vwan-%s-%s",element(split("/",var.vnet_ids[count.index]),length(split("/",var.vnet_ids[count.index]))-1),var.location,var.unique_id)
    virtual_hub_id            = azurerm_virtual_hub.vwan_hub.id
    remote_virtual_network_id = var.vnet_ids[count.index]
}