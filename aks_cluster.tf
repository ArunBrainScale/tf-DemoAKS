  resource "azurerm_resource_group" "aks" {
    name     = var.resource_group
    location = var.location
  }

  module "aks-network" {
    source = "./modules/AKS-Network"
    subnet_name         = var.subnet_name
    vnet_name           = var.vnet_name
    resource_group_name = azurerm_resource_group.aks.name
    subnet_cidr         = var.subnet_cidr
    appgw_subnetname    = var.appgw_subnetname
    appgw_cidr          = var.appgw_cidr
    location            = var.location
    address_space       = var.address_space
    network_security_group_name = var.network_security_group_name
  }

  module "acr" {
    source = "./modules/ACR"
    depends_on = [azurerm_resource_group.aks]
  }

  module "aks-cluster" {
    source = "./modules/AKS-Cluster"
    cluster_name             = var.cluster_name
    location                 = var.location
    os_type                  = var.os_type
    dns_prefix               = var.dns_prefix
    resource_group           = azurerm_resource_group.aks.name
    node_count               = var.node_count
    os_disk_size_gb          = "40"
    max_pods                 = "110"
    vm_size                  = var.vm_size
    vnet_subnet_id           = module.aks-network.aks_subnet_id
    appgw_subnetid           = module.aks-network.appgw_subnetid
    service_principal_client_id     = ""
    service_principal_client_secret = ""

    depends_on = [module.acr]
    
  }

  resource "azurerm_role_assignment" "resourcegroup_vnet" {
    principal_id = module.aks-cluster.identity
    scope = azurerm_resource_group.aks.id
    role_definition_name = "Contributor"
  }

  #ACR Role assignment

  resource "azurerm_role_assignment" "acrpull" {
    principal_id = module.aks-cluster.identity
    scope = module.acr.acr_id
    role_definition_name = "AcrPull"

    depends_on = [module.aks-cluster]
  }

  module "argo" {
    source = "./modules/ArgoCD"
    depends_on = [module.aks-cluster]
  }

  module "prometheus" {
    source = "./modules/Prometheus"
    depends_on = [module.aks-cluster]
  }

  module "istio" {
    source = "./modules/Istio"
    depends_on = [module.aks-cluster]
  }