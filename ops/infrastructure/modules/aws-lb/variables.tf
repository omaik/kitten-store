variable "instance_ids" {
  type = list(string)
  description = "aws instance ids"
}

variable "autoscaling_group_ids" {
  type = list(string)
  description = "aws autoscaling group ids"
}

variable "vpc" {
  type = object({
    vpc_id = string
    subnet_ids = list(string)
  })
  description = "VPC information"
}

variable "security_groups" {
  type = list(string)
  description = "security groups to assign"
}
