  variable "subnet_name" {
    description = "name to give the subnet"
    default = "AKS-subnet"
  }

  variable "resource_group_name" {
    description = "resource group that the vnet resides in"
  }

  variable "vnet_name" {
    description = "name of the vnet that this subnet will belong to"
  }

  variable "subnet_cidr" {
    description = "the subnet cidr range"
  }

  variable "location" {
    description = "the cluster location"
  }

  variable "address_space" {
    description = "Network address space"
    type = string
  }

  variable "network_security_group_name" {
    description = "network security group name"
  }

  variable "appgw_subnetname" {
    default = "Appgw-Subnet"
  }

  variable "appgw_cidr" {
    description = "appgw subnet cidr"
  }