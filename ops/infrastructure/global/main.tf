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

module "vpc" {
  source = "../modules/aws-vpc"

  vpc_name = "my vpc"
  cidr_block = var.cidr_block
  subnets_count = 2
}

# module "instance" {
#   source = "./modules/aws-app-instance"

#   vpc_id = module.vpc.vpc_id
#   subnet_id = module.vpc.subnet_ids[0]
#   name = "Webster"
# }
