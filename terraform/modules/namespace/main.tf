variable "name" {
  description = "Namespace name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging)"
  type        = string
}

variable "labels" {
  description = "Additional labels for the namespace"
  type        = map(string)
  default     = {}
}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.name

    labels = merge(
      {
        app         = "library"
        environment = var.environment
        managed-by  = "terraform"
      },
      var.labels
    )
  }
}

output "name" {
  description = "Namespace name"
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

