provider "aws" {
  region  = "us-east-2"
  profile = "test"
}

terraform {
  backend "s3" {
    profile = "test"
    bucket  = "terraform-state-363832864047"
    region  = "us-east-2"
  }
}


data "terraform_remote_state" "live" {
  backend = "s3"

  config = {
    profile = "test"
    bucket  = "terraform-state-363832864047"
    key     = "live/terraform.tfstate"
    region  = "us-east-2"
  }
}


locals {
  cluster_name     = data.terraform_remote_state.live.outputs.eks_cluster_name
  cluster_endpoint = data.terraform_remote_state.live.outputs.eks_cluster_endpoint
  cluster_ca       = data.terraform_remote_state.live.outputs.eks_certificate_authority
}


resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_-"
}

provider "kubernetes" {
  host                   = local.cluster_endpoint
  cluster_ca_certificate = base64decode(local.cluster_ca)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "test" {
  metadata {
    annotations = {
      name = "test-annotation"
    }

    name = "pull-request-${var.pr_id}"
  }
}

resource "kubernetes_config_map" "database_config" {
  metadata {
    name      = "database-config"
    namespace = kubernetes_namespace.test.metadata[0].name
  }
  data = {
    POSTGRES_DB       = "postgresdb"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = random_password.password.result
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.test.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          image             = "postgres:10.4"
          name              = "postgres"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 5432
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.database_config.metadata[0].name
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.test.metadata[0].name
  }
  spec {
    selector         = kubernetes_deployment.postgres.spec[0].selector[0].match_labels
    session_affinity = "ClientIP"
    port {
      port        = 5432
      target_port = 5432
    }

    type = "ClusterIP"
  }
}
