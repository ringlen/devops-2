variable "name" {
  description = "Service name (used for Deployment, Service and app label)"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy into"
  type        = string
}

variable "image" {
  description = "Container image"
  type        = string
}

variable "port" {
  description = "Container and service port"
  type        = number
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

variable "env" {
  description = "Plain environment variables"
  type        = map(string)
  default     = {}
}

variable "secret_env" {
  description = "Environment variables taken from a Secret"
  type = map(object({
    secret_name = string
    key         = string
  }))
  default = {}
}

variable "resources" {
  description = "Container resource requests and limits (optional)"
  type = object({
    requests = map(string)
    limits   = map(string)
  })
  default = null
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = { app = var.name }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = { app = var.name }
    }

    template {
      metadata {
        labels = { app = var.name }
      }

      spec {
        container {
          name              = var.name
          image             = var.image
          image_pull_policy = var.image_pull_policy

          port {
            container_port = var.port
          }

          dynamic "resources" {
            for_each = var.resources == null ? [] : [var.resources]
            content {
              requests = resources.value.requests
              limits   = resources.value.limits
            }
          }

          dynamic "env" {
            for_each = var.env
            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = var.secret_env
            content {
              name = env.key
              value_from {
                secret_key_ref {
                  name = env.value.secret_name
                  key  = env.value.key
                }
              }
            }
          }

          readiness_probe {
            tcp_socket {
              port = var.port
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          liveness_probe {
            tcp_socket {
              port = var.port
            }
            initial_delay_seconds = 15
            period_seconds        = 20
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector = { app = var.name }

    port {
      port        = var.port
      target_port = var.port
    }
  }
}

output "name" {
  description = "Service name"
  value       = kubernetes_service_v1.this.metadata[0].name
}