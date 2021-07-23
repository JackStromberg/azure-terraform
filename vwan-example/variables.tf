variable "rgName" {
  description = "Name of the Resource Group all resources should be deployed to."
  type = string
}
variable "vWANName" {
  description = "Name of your VWAN instance."
  type = string
}
variable "unique_id" {
  description = "A unique id for each resource."
  type = string
}
variable "vwanRegion" {
  description = "Region of the virtual wan resource."
  type = string
}
variable "vwanHubStartingOctect" {
  description = "VWAN Hub network space second octect value (will increment network by /24s)."
  type = number
}
variable "vnetSpokeStartingOctect" {
  description = "Virtual network spoke second octect value (will increment network by /16s)."
  type = number
}
variable "adminUsername" {
  description = "Test machine username."
  type = string
}
variable "adminPassword" {
  description = "Test machine password."
  type = string
}
variable "hubRegions" {
  description = "Region of the virtual wan resource."
  type = list(string)
}
variable "OnSite-GW-PIPs" {
  description = "Public IP address of on-premises VPN Gateway connecting to VWAN hub (one per region specified)."
  type = list(string)
}
variable "OnSite-GW-Model" {
  description = "Device model for on-premises gateway."
  type = string
}
variable "OnSite-GW-Vendor" {
  description = "Device vendor for on-premises gateway."
  type = string
}
variable "OnSite-GW-StartingOctect" {
  description = "Starting octect for on-premises IP ranges for an example VPN Connection."
  type = number
}