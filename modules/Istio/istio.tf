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

 resource "helm_release" "istio-base" {

   create_namespace = true
   namespace = "istio-system"
   name = "istio-base"
   repository = "https://istio-release.storage.googleapis.com/charts"
   chart = "base"

 }

 resource "helm_release" "istio-discovery" {

     namespace = "istio-system"
     name = "istio-discovery"
     repository = "https://istio-release.storage.googleapis.com/charts"
     chart = "istiod"
     wait = true

     depends_on = [helm_release.istio-base] 
 }

 resource "kubernetes_namespace" "istio-ingressns" {

     metadata {
       name = "istio-ingress"
       labels = {
         "istio-injection" = "enabled"
       }
     }
 }

 resource "helm_release" "istio-ingress" {

     namespace = "istio-ingress"
     name = "istio-ingress"
     repository = "https://istio-release.storage.googleapis.com/charts"
     chart = "gateway"
     wait = false

     depends_on = [kubernetes_namespace.istio-ingressns]
 }