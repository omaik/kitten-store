provider "aws" {
  region = "us-east-2"
  profile = "test"
}

terraform {
  backend "s3" {
    profile = "test"
    bucket = "terraform-state-363832864047"
    key    = "live/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    profile = "test"
    bucket = "terraform-state-363832864047"
    key    = "global/terraform.tfstate"
    region = "us-east-2"
  }
}

locals {
  vpc = {
    vpc_id = data.terraform_remote_state.global.outputs.vpc_id,
    subnet_ids = data.terraform_remote_state.global.outputs.subnet_ids
  }
}

module "instance" {
  source = "../modules/aws-app-instance"

  vpc = local.vpc
  assigned_security_groups = [module.db_instance.connector_group_id]
  load_balancer_group = module.load_balancer.security_group_id
  database_url = module.db_instance.connection_string
  name = "Webster"
  instance_count = 4
}

module "load_balancer" {
  source = "../modules/aws-lb"

  vpc = local.vpc
  instance_ids = module.instance.instance_ids
}

module "db_instance" {
  source = "../modules/aws-rds-instance"

  name = "databaser"
  vpc = local.vpc
}
