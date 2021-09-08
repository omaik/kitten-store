terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

module "cluster_role" {
  source = "../aws-iam-role"

  name = "${var.name}-cluster-role"
  assumable_type = "service"
  assumable_identifier = "eks.amazonaws.com"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}

module "nodes_role" {
  source = "../aws-iam-role"

  name = "${var.name}-nodes-role"
  assumable_type = "service"
  assumable_identifier = "ec2.amazonaws.com"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

resource "aws_security_group" "cluster_group" {
  name_prefix      = "${var.name}_api_access"
  description = "For EKS ${var.name}"
  vpc_id      = var.vpc.vpc_id

  ingress {
    description      = "HTTPS security group"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
resource "aws_eks_cluster" "cluster" {
  name     = var.name
  role_arn = module.cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = false
    security_group_ids      = [resource.aws_security_group.cluster_group.id]
    subnet_ids              = var.vpc.subnet_ids
  }
}

resource "aws_eks_node_group" "workers" {
  cluster_name    = var.name
  node_role_arn   = module.nodes_role.arn
  version         = var.cluster_version
  subnet_ids      = var.vpc.subnet_ids
  launch_template {
    id = resource.aws_launch_template.worker.id
    version = "$Latest"
  }

  scaling_config {
    desired_size  = 1
    max_size      = 1
    min_size      = 1
  }

  depends_on = [
    aws_eks_cluster.cluster
  ]
}


resource "aws_security_group" "worker_group" {
  name_prefix      = "${var.name}_worker"
  description = "For EKS worker ${var.name}"
  vpc_id      = var.vpc.vpc_id

  ingress {
    description      = "all for cluster"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups      = [resource.aws_security_group.cluster_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
   "kubernetes.io/cluster/${var.name}" = "shared"
  }
}

resource "aws_launch_template" "worker" {
  name_prefix = var.name
  instance_type = "t3.small"

  network_interfaces {
    security_groups = concat([resource.aws_security_group.worker_group.id], var.assigned_security_groups)
  }
}
