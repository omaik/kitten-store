
output "database_url" {
  sensitive = true
  value = module.db_instance.connection_string
}

output "eks_cluster_name" {
  value = module.eks_cluster.name
}

output "eks_certificate_authority" {
  value = module.eks_cluster.cluster_certificate_authority_data
}
