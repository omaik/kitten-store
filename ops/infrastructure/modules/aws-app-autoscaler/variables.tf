variable "name" {
  type = string
  description = "Name of the instance"
}

variable "vpc" {
  type = object({
    vpc_id = string
    subnet_ids = list(string)
  })
  description = "VPC information"
}

variable "launch_template_id" {
  type = string
  description = "Launch Template ID"
}
