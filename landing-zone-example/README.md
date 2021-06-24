## Overview
This is an example script to help walk through building a custom landing zone in Azure via Terraform.

## Goal
The goal of this is to show an example of how to create a cookie-cutter deployment of common resources and specify a parameterized input to deploy to multiple regions.

## Examples
The script has examples of how to leverage modules and variables to provide code portability, reusability, and help with readability.

## The script will provision the following resources:
1. Resource Group
2. 2 Virtual Networks
    1. Hub VNet
    2. Spoke VNet
3. 4 Subnets
    1. SubnetA/B for Hub VNet
    2. SubnetA/B for Spoke VNet
4. NSG + NSG Rule
5. UDR + Route Rule
6. Association of NSG to Spoke VNet Subnet A
7. Association of UDR to Spoke VNet Subnet A
8. Region VNet Peering between Hub and Spoke Vnet
9. Creates VWAN Hub
10. Creates VWAN ER and VPN Gateway
11. Creates VWAN Route Table
12. Creates VNet Connection between Hub VNet and VWAN Hub

Deployment of each environment is specified via an object defined in your tfvars file.
