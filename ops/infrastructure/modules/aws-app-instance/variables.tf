variable "name" {
  type = string
  description = "Name of the instance"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "subnet_id" {
  type = string
  description = "Subnet ID"
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
