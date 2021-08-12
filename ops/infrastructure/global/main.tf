provider "aws" {
  region = "us-east-2"
  profile = "test"
}

terraform {
  backend "s3" {
    profile = "test"
    bucket = "terraform-state-363832864047"
    key    = "global/terraform.tfstate"
    region = "us-east-2"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../modules/aws-vpc"

  vpc_name = "my vpc"
  cidr_block = var.cidr_block
  availability_zones = data.aws_availability_zones.available.names
}
