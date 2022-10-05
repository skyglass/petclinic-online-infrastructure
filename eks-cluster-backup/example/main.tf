module "aws-kubernetes-cluster" {
  source = "../"

  env_name           = "staging"
  aws_region         = "eu-central-1"
  cluster_name       = "petclinic-online-cluster"
  vpc_id             = "vpc-id"
  cluster_subnet_ids = ["id1", "id2", "id3", "id4"]

  nodegroup_subnet_ids     = ["id3", "id4"]
  nodegroup_disk_size      = "20"
  nodegroup_instance_types = ["t3.medium"]
  nodegroup_desired_size   = 1
  nodegroup_min_size       = 1
  nodegroup_max_size       = 3
}
