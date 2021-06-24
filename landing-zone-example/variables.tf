variable "lz" {
  description = "The landing zone object to be created"
  type = map(object({
    resource_group_name = string
    location = string
    tags = map(string)
    unique_id = string
    vnet_address_octect = number
    vwan_name = string
    vwan_resource_group = string
    vwan_hub_address_space = string
  }))
}