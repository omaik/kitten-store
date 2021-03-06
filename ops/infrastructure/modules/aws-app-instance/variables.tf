variable "instance_count" {
  type = number
  description = "Number of instances"
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
  description = "Launch template ID"
}
