output "public_endpoint" {
  value = aws_lb.main.dns_name
}

output "security_group_id" {
  value = aws_security_group.lb_sg.id
}
