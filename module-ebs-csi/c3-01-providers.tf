# Terraform AWS Provider Block
provider "aws" {
  region = var.aws_region
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host = var.cluster_endpoint 
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  token = var.cluster_token
}

# HELM Provider
provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    token                  = var.cluster_token
  }
}