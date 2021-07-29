output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "gw_id" {
  value = aws_internet_gateway.my_gw.id
}

output "rt_id" {
  value = aws_route_table.my_route_public.id
}

output "subnet_ids" {
  value = aws_subnet.my_subnet[*].id
}

output "availability_zones" {
  value = aws_subnet.my_subnet[*].availability_zone
}

output "web_ip" {
  value = aws_instance.web.public_ip
}
