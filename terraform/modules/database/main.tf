variable "name" {
  description = "Database service name, e.g. auth-db"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy into"
  type        = string
}

variable "database_name" {
  description = "PostgreSQL database name"
  type        = string
}

variable "secret_name" {
  description = "Secret with DB_USER and DB_PASSWORD keys"
  type        = string
}

variable "image" {
  description = "PostgreSQL image"
  type        = string
  default     = "postgres:15-alpine"
}

variable "storage" {
  description = "Persistent volume size"
  type        = string
  default     = "1Gi"
}

resource "kubernetes_stateful_set_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    service_name = var.name
    replicas     = 1

    selector {
      match_labels = { app = var.name }
    }

    template {
      metadata {
        labels = { app = var.name }
      }

      spec {
        container {
          name  = "postgres"
          image = var.image

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_DB"
            value = var.database_name
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = var.secret_name
                key  = "DB_USER"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = var.secret_name
                key  = "DB_PASSWORD"
              }
            }
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }

          readiness_probe {
            exec {
              command = ["pg_isready", "-U", "postgres"]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/postgresql/data"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = var.storage
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
      port        = 5432
      target_port = 5432
    }
  }
}

output "name" {
  description = "Database service name (DB_HOST for applications)"
  value       = kubernetes_service_v1.this.metadata[0].name
}