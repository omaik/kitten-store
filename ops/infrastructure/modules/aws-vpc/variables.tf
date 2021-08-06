variable "vpc_name" {
  type = string
  description = "VPC name"
}

variable "cidr_block" {
  type = string
  description = "CIDR block of VPC"
}

variable "subnets_count" {
  type = number
  description = "Count of subnets to create"
  default = 2
}
