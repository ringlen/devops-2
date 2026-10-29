variable "db_password" {
  description = "PostgreSQL password for db-credentials Secret"
  type        = string
  sensitive   = true
}