provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "my vpc"
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

# resource "aws_subnet" "my_subnet_1" {
#   vpc_id     = aws_vpc.my_vpc.id
#   cidr_block = cidrsubnet(var.cidr_block, 8, 1)
#   availability_zone = element(data.aws_availability_zones.available.names, 0)

#   tags = {
#     Name = "MySubnet-public-1"
#   }
# }

# resource "aws_route_table_association" "route_subnet_1" {
#   subnet_id      = aws_subnet.my_subnet_1.id
#   route_table_id = aws_route_table.my_route_public.id
# }

# resource "aws_subnet" "my_subnet_2" {
#   vpc_id     = aws_vpc.my_vpc.id
#   cidr_block = cidrsubnet(var.cidr_block, 8, 2)
#   availability_zone = element(data.aws_availability_zones.available.names, 1)

#   tags = {
#     Name = "MySubnet-public-2"
#   }
# }

# resource "aws_route_table_association" "route_subnet_2" {
#   subnet_id      = aws_subnet.my_subnet_2.id
#   route_table_id = aws_route_table.my_route_public.id
# }


resource "aws_subnet" "my_subnet" {
  count = 2

  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index + 1)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "MySubnet-public-${count.index + 1}"
  }
}

resource "aws_route_table_association" "route_subnet" {
  count = length(aws_subnet.my_subnet)
  subnet_id = element(aws_subnet.my_subnet[*].id, count.index)
  route_table_id = aws_route_table.my_route_public.id
}
