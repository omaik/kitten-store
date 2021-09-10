provider "aws" {
  region  = "us-east-2"
  profile = "test"
}

terraform {
  backend "s3" {
    profile = "test"
    bucket  = "terraform-state-363832864047"
    key     = "live/terraform.tfstate"
    region  = "us-east-2"
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    profile = "test"
    bucket  = "terraform-state-363832864047"
    key     = "global/terraform.tfstate"
    region  = "us-east-2"
  }
}

locals {
  vpc = {
    vpc_id     = data.terraform_remote_state.global.outputs.vpc_id,
    subnet_ids = data.terraform_remote_state.global.outputs.subnet_ids
  }
}

module "db_instance" {
  source = "../modules/aws-rds-instance"

  name = "databaser"
  vpc  = local.vpc
}

module "eks_cluster" {
  source                   = "../modules/aws-eks-cluster"
  name                     = "test_cluster"
  vpc                      = local.vpc
  assigned_security_groups = [module.db_instance.connector_group_id]
}
