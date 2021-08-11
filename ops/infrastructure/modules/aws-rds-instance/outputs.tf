output "host" {
  value = aws_db_instance.default.address
}

output "database" {
  value = aws_db_instance.default.name
}

output "user" {
  value = aws_db_instance.default.username
}

output "password" {
  value = aws_db_instance.default.password
}

output "connection_string" {
  sensitive = true
  value = "postgres://${aws_db_instance.default.username}:${aws_db_instance.default.password}@${aws_db_instance.default.address}:${aws_db_instance.default.port}/${aws_db_instance.default.name}"
}

output "connection_security_group_id" {
  value = "CHANGE ME"
}
