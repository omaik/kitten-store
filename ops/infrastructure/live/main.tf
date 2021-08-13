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

module "launch_template" {
  source = "../modules/aws-launch-template"

  vpc = local.vpc
  assigned_security_groups = [module.db_instance.connector_group_id]
  database_url = module.db_instance.connection_string
  name = "Webster"
}


module "instance" {
  source = "../modules/aws-app-instance"

  vpc = local.vpc
  instance_count = 2
  launch_template_id = module.launch_template.launch_template_id
}


module "autoscaling_group" {
  source = "../modules/aws-app-autoscaler"

  vpc = local.vpc
  launch_template_id = module.launch_template.launch_template_id
  name = "Webster"
}

module "load_balancer" {
  source = "../modules/aws-lb"

  vpc = local.vpc
  instance_ids = module.instance.instance_ids
  security_groups = [module.launch_template.connection_group_id]
  autoscaling_group_ids = [module.autoscaling_group.autoscaling_gpoup_id]
}

module "db_instance" {
  source = "../modules/aws-rds-instance"

  name = "databaser"
  vpc = local.vpc
}
