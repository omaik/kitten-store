
output "web_ip" {
  value = aws_instance.web.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
