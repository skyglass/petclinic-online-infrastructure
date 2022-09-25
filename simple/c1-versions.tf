# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.32.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.13.1"
    }    
  }
}
