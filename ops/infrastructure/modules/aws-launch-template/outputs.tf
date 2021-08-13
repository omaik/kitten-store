output "launch_template_id" {
  value = aws_launch_template.web.id
}

output "connection_group_id" {
  value = aws_security_group.connection_security_group.id
}
