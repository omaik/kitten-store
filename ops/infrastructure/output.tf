
output "web_ip" {
  value = module.instance.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
