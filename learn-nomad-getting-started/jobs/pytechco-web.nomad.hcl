job "pytechco-web" {
  type = "service"

  group "ptc-web" {
    count = 1

    task "ptc-web-task" {

      service {
        name    = "ptc-web-svc"
        port     = 5000
        provider = "nomad"
        address_mode = "driver"
      }


      template {
        data        = <<EOH
{{ range nomadService "redis-svc" }}
REDIS_HOST={{ .Address }}
REDIS_PORT={{ .Port }}
FLASK_HOST=0.0.0.0
REFRESH_INTERVAL=500
{{ end }}
EOH
        destination = "local/env.txt"
        env         = true
      }

      driver = "docker"

      config {
        image = "ghcr.io/hashicorp-education/learn-nomad-getting-started/ptc-web:1.0"
      }


      resources {
        cpu    = 10
        memory = 128
      }
    }
  }
}