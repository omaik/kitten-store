terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "random_password" "password" {
  length           = 16
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "postgres"
  identifier_prefix    = "id-${var.name}"
  name                 = var.name
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.main.name
  engine_version       = "11.11"
  instance_class       = "db.t2.micro"
  username             = "oleh"
  password             = random_password.password.result
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = var.vpc.subnet_ids

  tags = {
    Name = "Main DB Subnet group"
  }
}
