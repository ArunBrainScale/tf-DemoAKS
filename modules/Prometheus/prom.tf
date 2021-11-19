terraform {
   required_providers {
     kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.3"
     }
     helm = {
       source  = "hashicorp/helm"
       version = ">= 2.1.0"
     }

   }
 }

 resource "helm_release" "prometheus-stack" {

   create_namespace = true
   namespace = "prometheus"
   name = "prometheus-stack"
   repository = "https://prometheus-community.github.io/helm-charts"
   force_update = false
   dependency_update = false
   chart = "kube-prometheus-stack"

 }