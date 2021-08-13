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

variable "assigned_security_groups" {
  type = list(string)
  description = "Assigned security groups to the instance"
  default = []
}

variable "database_url" {
  type = string
  description = "connection string to database"
}
