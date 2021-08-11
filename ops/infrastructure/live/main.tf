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
  global_config = data.terraform_remote_state.global.outputs
}

module "instance" {
  source = "../modules/aws-app-instance"

  vpc_id = local.global_config.vpc_id
  subnet_id = local.global_config.subnet_ids[0]
  assigned_security_groups = [module.db_instance.connector_group_id]
  name = "Webster"
}

module "db_instance" {
  source = "../modules/aws-rds-instance"

  name = "databaser"
  vpc = {
    vpc_id = local.global_config.vpc_id
    subnet_ids = local.global_config.subnet_ids
  }
}
