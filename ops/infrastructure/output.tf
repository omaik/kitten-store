output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "gw_id" {
  value = aws_internet_gateway.my_gw.id
}

output "rt_id" {
  value = aws_route_table.my_route_public.id
}
