terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>2.64"
        }
    }
}
provider "azurerm" {
    features {}
}

# Create Azure Resource Groups
module rg {
    source = "./modules/resource_groups"
    for_each = var.lz

    resource_group_name = each.value.resource_group_name
    location = each.value.location
    tags = each.value.tags
}

# Create Azure Virtual Networks and Subnets
module lz_vnets {
    source = "./modules/lz_vnets"
    for_each = var.lz

    vnet_address_octect             = each.value.vnet_address_octect
    location                        = each.value.location
    resource_group_name             = each.value.resource_group_name
    tags                            = each.value.tags
    unique_id                       = each.value.unique_id
    depends_on = [
        module.rg
    ]
}

# Create Azure NSGs and NSG rules
module lz_nsgs {
    source = "./modules/lz_nsgs"
    for_each = var.lz

    location                        = each.value.location
    resource_group_name             = each.value.resource_group_name
    tags                            = each.value.tags
    unique_id                       = each.value.unique_id
    depends_on = [
        module.rg
    ]
}

# Create Azure Route Tables and Route Table rules
module lz_udrs {
    source = "./modules/lz_udrs"
    for_each = var.lz

    location                        = each.value.location
    resource_group_name             = each.value.resource_group_name
    tags                            = each.value.tags
    unique_id                       = each.value.unique_id
    depends_on = [
        module.rg
    ]
}

# Associate Azure NSG to a subnet
module vnet_subnet_nsg_association {
  source = "./modules/lz_nsgs_associations"
  for_each = var.lz

  subnet_id = module.lz_vnets[each.key].spoke_subnetA.id
  network_security_group_id = module.lz_nsgs[each.key].nsg_spoke_subnetA.id
}

# Associate Azure UDR to a subnet
module vnet_subnet_udr_association {
  source = "./modules/lz_udrs_associations"
  for_each = var.lz

  subnet_id = module.lz_vnets[each.key].spoke_subnetA.id
  udr_id = module.lz_udrs[each.key].udr_spoke_subnetA.id
}

# Create Azure Virtual Network Peerings
module vnet_peerings {
    source = "./modules/lz_vnet_peerings"
    for_each = var.lz

    resource_group_name = each.value.resource_group_name
    source_vnet_id = module.lz_vnets[each.key].hub_network.id
    destination_vnet_id = module.lz_vnets[each.key].spoke_network.id
}

# Create Azure Load Balancers
module lz_loadbalancers {
    source = "./modules/lz_loadbalancers"
    for_each = var.lz

    location                        = each.value.location
    resource_group_name             = each.value.resource_group_name
    tags                            = each.value.tags
    unique_id                       = each.value.unique_id
    depends_on = [
        module.lz_vnets
    ]
}

# Get VWAN information
data "azurerm_virtual_wan" "vwan" {
    for_each = var.lz

    name                = each.value.vwan_name
    resource_group_name = each.value.vwan_resource_group
}

# Create VHUB components
module vhub {
    source = "./modules/lz_vhub"
    for_each = var.lz

    location                        = each.value.location
    resource_group_name             = each.value.resource_group_name
    tags                            = each.value.tags
    unique_id                       = each.value.unique_id
    vwan_id                         = data.azurerm_virtual_wan.vwan[each.key].id
    vwan_rg                         = each.value.vwan_resource_group
    vnet_ids                        = [module.lz_vnets[each.key].hub_network.id, module.lz_vnets[each.key].spoke_network.id]
    vwan_hub_address_space          = each.value.vwan_hub_address_space
    depends_on = [
        module.vnet_peerings
    ]
}