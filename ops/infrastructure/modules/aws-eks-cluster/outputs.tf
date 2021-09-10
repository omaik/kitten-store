output "name" {
  value = var.name
}

output "cluster_certificate_authority_data" {
  value = resource.aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_endpoint" {
  value = resource.aws_eks_cluster.cluster.endpoint
}
