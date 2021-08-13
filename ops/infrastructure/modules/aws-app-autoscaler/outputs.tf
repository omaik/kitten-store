# output "public_ips" {
#   value = aws_instance.web.*.public_ip
# }

output "autoscaling_gpoup_id" {
  value = aws_autoscaling_group.web.id
}
