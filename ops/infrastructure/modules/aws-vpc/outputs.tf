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
  value = [for s in aws_subnet.my_subnet : s.id]
}

output "availability_zones" {
  value = [for s in aws_subnet.my_subnet : s.availability_zone]
}
