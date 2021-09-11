output "database_url" {
  value     = "postgres://$postgres:${random_password.password.result}@${kubernetes_service.postgres.spec[0].cluster_ip}:5432/app"
  sensitive = true
}

output "namespace" {
  value = kubernetes_namespace.test.metadata[0].name
}

output "cluster_name" {
  value = local.cluster_name
}
