job "pytechco-redis" {
  type = "service"

  group "ptc-redis" {
    count = 1

    task "redis-task" {
      driver = "docker"

      service {
        name         = "redis-svc"
        port         = 6379
        provider     = "nomad"
        address_mode = "driver"
      }

      config {
        image = "redis:7.4.1-alpine"
      }

      resources {
        cpu    = 10
        memory = 128
      }
    }
  }
}