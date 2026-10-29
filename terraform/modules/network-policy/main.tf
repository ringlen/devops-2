variable "namespace" {
  description = "Namespace the policies are applied to"
  type        = string
}

variable "databases" {
  description = "Services that have a database (database pods are named <name>-db)"
  type        = set(string)
}

variable "services" {
  description = "Application services and their ports"
  type        = map(number)
}

variable "ingress_namespace" {
  description = "Namespace of the ingress controller"
  type        = string
  default     = "ingress-nginx"
}

# Забороняємо весь вхідний трафік до подів namespace
resource "kubernetes_network_policy_v1" "default_deny_ingress" {
  metadata {
    name      = "default-deny-ingress"
    namespace = var.namespace
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]
  }
}

# База доступна лише для свого сервісу
resource "kubernetes_network_policy_v1" "allow_db" {
  for_each = var.databases

  metadata {
    name      = "allow-${each.key}-db"
    namespace = var.namespace
  }

  spec {
    pod_selector {
      match_labels = { app = "${each.key}-db" }
    }

    ingress {
      from {
        pod_selector {
          match_labels = { app = each.key }
        }
      }

      ports {
        port     = "5432"
        protocol = "TCP"
      }
    }

    policy_types = ["Ingress"]
  }
}

# Сервіси доступні з того ж namespace та від ingress-контролера
resource "kubernetes_network_policy_v1" "allow_service" {
  for_each = var.services

  metadata {
    name      = "allow-${each.key}"
    namespace = var.namespace
  }

  spec {
    pod_selector {
      match_labels = { app = each.key }
    }

    ingress {
      from {
        pod_selector {}
      }

      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = var.ingress_namespace
          }
        }
      }

      ports {
        port     = tostring(each.value)
        protocol = "TCP"
      }
    }

    policy_types = ["Ingress"]
  }
}