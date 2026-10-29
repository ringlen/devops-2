variable "name" {
  description = "Registry name"
  type        = string
  default     = "registry"
}

variable "namespace" {
  description = "Namespace to deploy into"
  type        = string
}

variable "image" {
  description = "Registry image"
  type        = string
  default     = "registry:2"
}

variable "port" {
  description = "Registry port"
  type        = number
  default     = 5000
}

variable "storage" {
  description = "Persistent volume size for images"
  type        = string
  default     = "1Gi"
}

resource "kubernetes_persistent_volume_claim_v1" "this" {
  metadata {
    name      = "${var.name}-data"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = var.storage
      }
    }
  }

  # Том прив'язується лише після створення пода, тому не чекаємо
  wait_until_bound = false
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = { app = var.name }
  }

  spec {
    replicas = 1

    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = { app = var.name }
    }

    template {
      metadata {
        labels = { app = var.name }
      }

      spec {
        container {
          name  = var.name
          image = var.image

          port {
            container_port = var.port
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/registry"
          }

          readiness_probe {
            http_get {
              path = "/v2/"
              port = var.port
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }

        volume {
          name = "data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.this.metadata[0].name
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
  description = "Registry service name"
  value       = kubernetes_service_v1.this.metadata[0].name
}

output "port" {
  description = "Registry port"
  value       = var.port
}

output "address" {
  description = "In-cluster registry address"
  value       = "${var.name}.${var.namespace}.svc.cluster.local:${var.port}"
}