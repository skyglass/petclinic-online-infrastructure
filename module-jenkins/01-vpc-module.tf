# AWS Availability Zones Datasource
data "aws_availability_zones" "available" {
}

# Create VPC Terraform Module
module "jenkins_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"
  #version = "~> 3.11"

  # VPC Basic Details
  name = "jenkins_vpc"
  cidr = "10.0.0.0/16"
  azs             = data.aws_availability_zones.available.names
  public_subnets  = ["10.0.101.0/24"]

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

}