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

resource "aws_key_pair" "id_rsa" {
  key_name   = "id_rsa"
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
    security_groups  = [var.load_balancer_group]
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
  count = var.instance_count
  ami           = data.aws_ami.aws_linux.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.id_rsa.key_name
  vpc_security_group_ids = concat([aws_security_group.ec2_sec_group.id], var.assigned_security_groups)
  subnet_id = element(var.vpc.subnet_ids, count.index)
  user_data = data.template_file.user_data.rendered

  lifecycle {
    ignore_changes = [tags, ami]
  }
  tags = {
    Name = var.name
  }
}
