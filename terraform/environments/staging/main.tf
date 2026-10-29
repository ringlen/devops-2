module "namespace" {
  source = "../../modules/namespace"

  name        = "library-staging"
  environment = "staging"
}

resource "kubernetes_secret_v1" "db_credentials" {
  metadata {
    name      = "db-credentials"
    namespace = module.namespace.name
  }

  data = {
    DB_USER     = "postgres"
    DB_PASSWORD = var.db_password
  }
}

locals {
  replicas    = 2
  secret_name = kubernetes_secret_v1.db_credentials.metadata[0].name

  # Сервіси, які мають власну базу даних
  databases = toset(["auth", "catalog", "libraryfav", "billing"])

  # Порт кожного сервісу та наявність бази
  services = {
    auth       = { port = 8081, db = true }
    catalog    = { port = 8082, db = true }
    ebook      = { port = 8083, db = false }
    audio      = { port = 8084, db = false }
    libraryfav = { port = 8085, db = true }
    billing    = { port = 8086, db = true }
  }

  db_secret_env = {
    DB_USER = {
      secret_name = local.secret_name
      key         = "DB_USER"
    }
    DB_PASSWORD = {
      secret_name = local.secret_name
      key         = "DB_PASSWORD"
    }
  }

  audio_resources = {
    requests = { cpu = "100m", memory = "64Mi" }
    limits   = { cpu = "300m", memory = "128Mi" }
  }
}

module "database" {
  for_each = local.databases
  source   = "../../modules/database"

  name          = "${each.key}-db"
  namespace     = module.namespace.name
  database_name = each.key
  secret_name   = local.secret_name
}

module "service" {
  for_each = local.services
  source   = "../../modules/service"

  name      = each.key
  namespace = module.namespace.name
  image     = "library-${each.key}:1.0"
  port      = each.value.port
  replicas  = local.replicas

  env = merge(
    { PORT = tostring(each.value.port) },
    { for k, v in { DB_HOST = "${each.key}-db", DB_NAME = each.key } : k => v if each.value.db }
  )

  secret_env = { for k, v in local.db_secret_env : k => v if each.value.db }

  resources = each.key == "audio" ? local.audio_resources : null

  depends_on = [module.database]
}

module "registry" {
  source = "../../modules/registry"

  namespace = module.namespace.name
}

module "network_policy" {
  source = "../../modules/network-policy"

  namespace = module.namespace.name
  databases = local.databases
  services = merge(
    { for name, svc in local.services : name => svc.port },
    { registry = module.registry.port }
  )
}