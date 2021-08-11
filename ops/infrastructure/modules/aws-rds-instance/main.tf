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

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = var.vpc.subnet_ids

  tags = {
    Name = "Main DB Subnet group"
  }
}

resource "aws_security_group" "connection_security_group" {
  name_prefix = "${var.name}-db-connector-"
  description = "Connector for RDS"
  vpc_id      = var.vpc.vpc_id
}

resource "aws_security_group" "rds_group" {
  name_prefix = "rds-securiry-group"
  description = "RDS Ingress Rules"
  vpc_id      = var.vpc.vpc_id
    ingress {
    description      = "Postgres PORT"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = [aws_security_group.connection_security_group.id]
  }
}

resource "aws_db_instance" "default" {
  vpc_security_group_ids = [aws_security_group.rds_group.id]
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
