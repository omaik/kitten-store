terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_instance" "web" {
  count = var.instance_count
  subnet_id = element(var.vpc.subnet_ids, count.index)
  launch_template {
    id = var.launch_template_id
    version = "$LATEST"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
