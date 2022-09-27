# Terraform Remote State Datasource - Remote Backend AWS S3
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "skyglass-terraform-on-aws-eks"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = "eu-central-1" 
  }
}

