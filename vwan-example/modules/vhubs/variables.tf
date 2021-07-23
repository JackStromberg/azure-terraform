variable location {
    type = string
}
variable resource_group_name {
    type = string
}
variable unique_id {
    type = string
}
variable vwan_id {
    type = string
}
variable vwan_rg {
    type = string
}
variable vwan_hub_address_space {
    type = string
}
variable onprem_address_second_octect {
    type = string
}
variable onprem_address_third_octect {
    type = string
}
variable onprem_address_third_octect2 {
    type = string
}
variable SiteLinkPublicIP {
    type = string
}
variable OnSite-GW-Model {
    type = string
}
variable OnSite-GW-Vendor {
    type = string
}
variable vnet_ids {
    type = list(string)
}
variable tags {
    type = map(string)
}