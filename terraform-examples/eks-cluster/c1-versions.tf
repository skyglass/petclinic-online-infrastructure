# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.32.0"
     }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "skyglass-terraform-on-aws-eks"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = "eu-central-1" 
 
    # For State Locking
    dynamodb_table = "skyglass-dev-ekscluster"    
  }
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}