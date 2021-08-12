variable "instance_ids" {
  type = list(string)
  description = "aws instance ids"
}

variable "vpc" {
  type = object({
    vpc_id = string
    subnet_ids = list(string)
  })
  description = "VPC information"
}
