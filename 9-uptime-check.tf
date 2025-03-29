resource "google_monitoring_uptime_check_config" "http_check" {
  display_name = "Global Web Server Uptime Check"

  http_check {
    path    = "/"
    port    = 80
    use_ssl = false
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = google_compute_global_forwarding_rule.http_forwarding_rule.ip_address
    }
  }

  timeout = "10s"
  period  = "60s"
}