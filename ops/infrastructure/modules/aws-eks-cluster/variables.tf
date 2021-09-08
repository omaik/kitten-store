variable "name" {
  type = string
  description = "Name of EKS cluster"
}

variable "cluster_version" {
  type = string
  description = "Kubernetis version of EKS cluster"
  default = "1.21"
}

variable "assigned_security_groups" {
  type = list(string)
  description = "assigned groups to worker node"
}

variable "vpc" {
  type = object({
    vpc_id = string
    subnet_ids = list(string)
  })
  description = "VPC information"
}
