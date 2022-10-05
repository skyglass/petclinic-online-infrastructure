output "eks_cluster_id" {
  value = aws_eks_cluster.petclinic-online.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.petclinic-online.name
}

output "eks_cluster_certificate_data" {
  value = aws_eks_cluster.petclinic-online.certificate_authority.0.data
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.petclinic-online.endpoint
}

output "eks_cluster_nodegroup_id" {
  value = aws_eks_node_group.petclinic-online-node-group.id
}

output "eks_cluster_security_group_id" {
  value = aws_security_group.petclinic-online-cluster.id
}