variable "vpc_name" {
  type = string
  description = "VPC name"
}

variable "cidr_block" {
  type = string
  description = "CIDR block of VPC"
}

variable "availability_zones" {
  type = list(string)
  description = "Availability zones to define subnets for"
}
