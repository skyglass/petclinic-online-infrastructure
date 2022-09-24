terraform {
  backend "s3" {
    bucket = "petclinic-online-infrastructure"
    key    = "petclinic-online-staging"
    region = "eu-central-1"
  }
}

locals {
  env_name         = "staging"
  aws_region       = "eu-central-1"
  k8s_cluster_name = "petclinic-online-cluster"
}

provider "aws" {
  region = local.aws_region
}

data "aws_eks_cluster" "petclinic-online" {
  name = module.aws-kubernetes-cluster.eks_cluster_id
}

module "aws-network" {
  source = "./module-aws-network"

  env_name              = local.env_name
  vpc_name              = "petclinic-online-VPC"
  cluster_name          = local.k8s_cluster_name
  aws_region            = local.aws_region
  main_vpc_cidr         = "10.10.0.0/16"
  public_subnet_a_cidr  = "10.10.0.0/18"
  public_subnet_b_cidr  = "10.10.64.0/18"
  private_subnet_a_cidr = "10.10.128.0/18"
  private_subnet_b_cidr = "10.10.192.0/18"
}

module "aws-kubernetes-cluster" {
  source = "./module-aws-kubernetes"

  petclinic-online_namespace = "petclinic-online"
  env_name                   = local.env_name
  aws_region                 = local.aws_region
  cluster_name               = local.k8s_cluster_name
  vpc_id                     = module.aws-network.vpc_id
  cluster_subnet_ids         = module.aws-network.public_subnet_ids

  nodegroup_subnet_ids     = module.aws-network.private_subnet_ids
  nodegroup_disk_size      = "20"
  nodegroup_instance_types = ["t3.medium"]
  nodegroup_desired_size   = 1
  nodegroup_min_size       = 1
  nodegroup_max_size       = 5
}

# Create namespace
# Use kubernetes provider to work with the kubernetes cluster API
provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.petclinic-online.certificate_authority.0.data)
  host                   = data.aws_eks_cluster.petclinic-online.endpoint
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", "${data.aws_eks_cluster.petclinic-online.name}"]
  }
}

# Create a namespace for petclinic-online microservice pods
resource "kubernetes_namespace" "petclinic-online-namespace" {
  metadata {
    name = "petclinic-online"
  }
}

module "argo-cd-server" {
  source = "./module-argo-cd"

  aws_region            = local.aws_region
  kubernetes_cluster_id = data.aws_eks_cluster.petclinic-online.id

  kubernetes_cluster_name      = module.aws-kubernetes-cluster.eks_cluster_name
  kubernetes_cluster_cert_data = module.aws-kubernetes-cluster.eks_cluster_certificate_data
  kubernetes_cluster_endpoint  = module.aws-kubernetes-cluster.eks_cluster_endpoint

  eks_nodegroup_id = module.aws-kubernetes-cluster.eks_cluster_nodegroup_id
}

module "traefik" {
  source = "./module-aws-traefik"

  aws_region                   = local.aws_region
  kubernetes_cluster_id        = data.aws_eks_cluster.petclinic-online.id
  kubernetes_cluster_name      = module.aws-kubernetes-cluster.eks_cluster_name
  kubernetes_cluster_cert_data = module.aws-kubernetes-cluster.eks_cluster_certificate_data
  kubernetes_cluster_endpoint  = module.aws-kubernetes-cluster.eks_cluster_endpoint

  eks_nodegroup_id = module.aws-kubernetes-cluster.eks_cluster_nodegroup_id
}
