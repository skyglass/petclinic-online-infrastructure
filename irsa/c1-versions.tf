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
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "skyglass-terraform-on-aws-eks"
    key    = "dev/app1k8s/terraform.tfstate"
    region = "eu-central-1" 

    # For State Locking
    dynamodb_table = "skyglass-dev-app1k8s"    
  }   
}
