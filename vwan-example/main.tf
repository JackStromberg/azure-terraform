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

    resource_group_name = var.rgName
    location = var.vwanRegion
    tags = null
}

# Create Azure Virtual Networks and Subnets
module vnets {
    source = "./modules/vnets"
    count = length(var.hubRegions)

    vnet_address_octect             = var.vnetSpokeStartingOctect+count.index
    location                        = var.hubRegions[count.index]
    resource_group_name             = module.rg.name
    unique_id                       = var.unique_id

    tags                            = null
}

# Create NSG rules to allow RDP to Test VMs
module nsgs {
    source = "./modules/nsgs"
    count = length(var.hubRegions)

    location                        = var.hubRegions[count.index]
    resource_group_name             = module.rg.name
    unique_id                       = var.unique_id

    tags                            = null
}

# Associate Azure NSG to a subnet
module nsg_subnet_associations {
  source = "./modules/nsgs_associations"
  count = length(var.hubRegions)

  subnet_id = module.vnets[count.index].spoke_subnetA.id
  network_security_group_id = module.nsgs[count.index].nsg_spoke_subnetA.id
}

# Create Test VMs
module vms {
    source = "./modules/vms"
    count = length(var.hubRegions)

    location                        = var.hubRegions[count.index]
    resource_group_name             = module.rg.name
    unique_id                       = var.unique_id
    subnet_id                       = module.vnets[count.index].spoke_subnetA.id
    adminUsername                   = var.adminUsername
    adminPassword                   = var.adminPassword
    
    tags                            = null
}

# Get VWAN information
module vwan {
    source = "./modules/vwan"

    name                = var.vWANName
    location            = var.vwanRegion
    resource_group_name = module.rg.name
    tags                = null
}

# Create VHUB components
module vhubs {
    source = "./modules/vhubs"
    count = length(var.hubRegions)

    location                        = var.hubRegions[count.index]
    resource_group_name             = module.rg.name
    tags                            = null
    unique_id                       = var.unique_id
    vwan_id                         = module.vwan.id
    vwan_rg                         = module.rg.name
    vnet_ids                        = [module.vnets[count.index].spoke_network.id]
    vwan_hub_address_space          = "10.${var.vwanHubStartingOctect}.${count.index}.0/24"
    onprem_address_second_octect    = var.OnSite-GW-StartingOctect
    onprem_address_third_octect     = (count.index % 2) + count.index
    onprem_address_third_octect2    = ((count.index+1) % 2) + count.index
    SiteLinkPublicIP                = var.OnSite-GW-PIPs[count.index]
    OnSite-GW-Model                 = var.OnSite-GW-Model
    OnSite-GW-Vendor                = var.OnSite-GW-Vendor
}