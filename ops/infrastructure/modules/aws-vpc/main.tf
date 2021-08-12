terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  availability_zones = sort(var.availability_zones)
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my gateway"
  }
}

resource "aws_route_table" "my_route_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }

  tags = {
    Name = "MyRoute-public"
  }
}

resource "aws_subnet" "my_subnet" {
  for_each = toset(local.availability_zones)

  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, index(local.availability_zones, each.key) + 1)
  availability_zone = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet-public-${index(local.availability_zones, each.key) + 1}"
  }
}

resource "aws_route_table_association" "route_subnet" {
  for_each = aws_subnet.my_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.my_route_public.id
}
