
output "web_ips" {
  value = module.instance.public_ips
}

output "public_endpoint" {
  value = module.load_balancer.public_endpoint
}

output "connection_string" {
  sensitive = true
  value = module.db_instance.connection_string
}
