variable "name" {
  type = string
  description = "Name of the RDS instance"
}

variable "vpc" {
  type = object({
    vpc_id = string
    subnet_ids = list(string)
  })
  description = "VPC information"
}
