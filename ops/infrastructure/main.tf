provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "local_file" "id_rsa" {
    filename = "${path.module}/id_rsa.pub"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
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

resource "aws_subnet" "my_subnet" {
  count = 2

  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index + 1)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet-public-${count.index + 1}"
  }
}

resource "aws_route_table_association" "route_subnet" {
  count = length(aws_subnet.my_subnet)
  subnet_id = element(aws_subnet.my_subnet[*].id, count.index)
  route_table_id = aws_route_table.my_route_public.id
}

resource "aws_key_pair" "id_rsa" {
  key_name   = "id_rsa"
  public_key = data.local_file.id_rsa.content
}

resource "aws_security_group" "ec2_sec_group" {
  name_prefix      = "ec2_sec_group"
  description = "For EC2 traffic changed 2"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    description      = "HTTP from outside world"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "ec2_sec_group"
  }
}

data "aws_ami" "aws_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.aws_linux.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.id_rsa.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sec_group.id]
  subnet_id = aws_subnet.my_subnet[0].id


  lifecycle {
    ignore_changes = [tags, ami]
  }
  tags = {
    Name = "Web"
  }
}
