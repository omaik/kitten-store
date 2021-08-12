terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_security_group" "lb_sg" {
  name_prefix      = "lb_sec_group"
  description = "LB security group"
  vpc_id      = var.vpc.vpc_id

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
    Name = "lb_sec_group"
  }
}

resource "aws_lb" "main" {
  name               = "Main"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.vpc.subnet_ids
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name     = "mainlbtargetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc.vpc_id

  health_check {
    enabled = true
    path = "/kittens/info"
    interval = 5
    timeout = 2
  }
}


resource "aws_lb_target_group_attachment" "main" {
  for_each = toset(var.instance_ids)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = each.key
  port             = 80
}
