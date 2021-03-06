terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  name = "Web group"
  capacity_rebalance  = true
  desired_capacity    = 1
  max_size            = 6
  min_size            = 1
  vpc_zone_identifier = var.vpc.subnet_ids
  health_check_grace_period = 120
  health_check_type         = "ELB"

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
}
