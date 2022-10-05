provider "aws" {
  region = local.aws_region
}

# module "aws-network" {
#   source = "./module-aws-network"
# 
#   env_name              = local.env_name
#   vpc_name              = "petclinic-online-VPC"
#  cluster_name          = local.k8s_cluster_name
#  aws_region            = local.aws_region
#  main_vpc_cidr         = "10.10.0.0/16"
#  public_subnet_a_cidr  = "10.10.0.0/18"
#  public_subnet_b_cidr  = "10.10.64.0/18"
#  private_subnet_a_cidr = "10.10.128.0/18"
#  private_subnet_b_cidr = "10.10.192.0/18"
#}

module "kubernetes-cluster" {
  source = "./module-eks-cluster"

  aws_region                 = var.aws_region
  business_division          = var.business_division
  environment                = var.environment
  cluster_name               = var.cluster_name
  nodegroup_disk_size      = "20"
  nodegroup_instance_types = ["t3.medium"]
  nodegroup_desired_size   = 1
  nodegroup_min_size       = 1
  nodegroup_max_size       = 5
}

# Create namespace
# Use kubernetes provider to work with the kubernetes cluster API

# provider "kubernetes" {
#   host = module.kubernetes-cluster.cluster_endpoint 
#   cluster_ca_certificate = base64decode(module.kubernetes-cluster.cluster_certificate_authority_data)
#   token = module.kubernetes-cluster.cluster_token
# }

# Create a namespace for petclinic-online microservice pods
# resource "kubernetes_namespace" "petclinic-online-namespace" {
#   metadata {
#     name = "petclinic-online"
#   }
# }

module "argo-cd-server" {
  source = "./module-argo-cd"

  aws_region                   = local.aws_region
  kubernetes_cluster_id        = module.kubernetes-cluster.cluster_id
  kubernetes_cluster_name      = module.kubernetes-cluster.cluster_name
  kubernetes_cluster_cert_data = module.kubernetes-cluster.cluster_certificate_authority_data
  kubernetes_cluster_endpoint  = module.kubernetes-cluster.cluster_endpoint
  eks_nodegroup_id             = module.kubernetes-cluster.cluster_nodegroup_id
}

module "ebs-csi" {
  source = "./module-ebs-csi"

  aws_region                                       = local.aws_region
  cluster_id                                       = module.kubernetes-cluster.cluster_id
  cluster_endpoint                                 = module.kubernetes-cluster.cluster_endpoint
  cluster_certificate_authority_data               = module.kubernetes-cluster.cluster_certificate_authority_data
  cluster_token                                    = module.kubernetes-cluster.cluster_token
  aws_iam_openid_connect_provider_arn              = module.kubernetes-cluster.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_extract_from_arn = module.kubernetes-cluster.aws_iam_openid_connect_provider_extract_from_arn
}

module "load-balancer" {
  source = "./module-load-balancer"

  aws_region                                       = local.aws_region
  vpc_id                                           = module.kubernetes-cluster.vpc_id
  cluster_id                                       = module.kubernetes-cluster.cluster_id
  cluster_endpoint                                 = module.kubernetes-cluster.cluster_endpoint
  cluster_certificate_authority_data               = module.kubernetes-cluster.cluster_certificate_authority_data
  cluster_token                                    = module.kubernetes-cluster.cluster_token
  aws_iam_openid_connect_provider_arn              = module.kubernetes-cluster.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_extract_from_arn = module.kubernetes-cluster.aws_iam_openid_connect_provider_extract_from_arn
}

module "sample-app" {
  source = "./module-sample-app"

  aws_region                                       = local.aws_region
  vpc_id                                           = module.kubernetes-cluster.vpc_id
  cluster_id                                       = module.kubernetes-cluster.cluster_id
  cluster_endpoint                                 = module.kubernetes-cluster.cluster_endpoint
  cluster_certificate_authority_data               = module.kubernetes-cluster.cluster_certificate_authority_data
  cluster_token                                    = module.kubernetes-cluster.cluster_token
  aws_iam_openid_connect_provider_arn              = module.kubernetes-cluster.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_extract_from_arn = module.kubernetes-cluster.aws_iam_openid_connect_provider_extract_from_arn
}

#module "traefik" {
#  source = "./module-aws-traefik"
#
#  aws_region                   = local.aws_region
#  kubernetes_cluster_id        = data.aws_eks_cluster.petclinic-online.id
#  kubernetes_cluster_name      = module.aws-kubernetes-cluster.eks_cluster_name
#  kubernetes_cluster_cert_data = module.aws-kubernetes-cluster.eks_cluster_certificate_data
#  kubernetes_cluster_endpoint  = module.aws-kubernetes-cluster.eks_cluster_endpoint
#
#  eks_nodegroup_id = module.aws-kubernetes-cluster.eks_cluster_nodegroup_id
#}
