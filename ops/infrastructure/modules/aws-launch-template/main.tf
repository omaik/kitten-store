terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "local_file" "id_rsa" {
    filename = "${path.module}/id_rsa.pub"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/app_user_data.sh.tpl")}"
  vars = {
    database_url = var.database_url
  }
}

resource "aws_key_pair" "id_rsa3" {
  key_name   = "id_rsa3"
  public_key = data.local_file.id_rsa.content
}

resource "aws_security_group" "ec2_sec_group" {
  name_prefix      = "${var.name}_sec_group"
  description = "For EC2 ${var.name}"
  vpc_id      = var.vpc.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    description      = "HTTP from security group"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.connection_security_group.id]
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


resource "aws_security_group" "connection_security_group" {
  name_prefix = "${var.name}-ec2-connector-"
  description = "Connector for EC2"
  vpc_id      = var.vpc.vpc_id
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

resource "aws_launch_template" "web" {
  name_prefix = var.name
  key_name = aws_key_pair.id_rsa3.key_name
  image_id = data.aws_ami.aws_linux.id
  instance_type = "t2.micro"
  user_data = base64encode(data.template_file.user_data.rendered)

  network_interfaces {
    security_groups = concat([aws_security_group.ec2_sec_group.id], var.assigned_security_groups)
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.name
    }
  }
}
