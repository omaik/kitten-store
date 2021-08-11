
output "web_ip" {
  value = module.instance.public_ip
}

output "connection_string" {
  sensitive = true
  value = module.db_instance.connection_string
}
