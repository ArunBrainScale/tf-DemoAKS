

#resource "null_resource" "argo" {
#    provisioner "local-exec" {
#      command = "kubectl create ns argocd"
#    }

#    provisioner "local-exec" {
#        command = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
      
#    }
#  }

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

 resource "helm_release" "argo" {

   create_namespace = true
   namespace = "argocd"
   name = "argo-cd"
   repository = "https://argoproj.github.io/argo-helm"
   chart = "argo-cd"

 }