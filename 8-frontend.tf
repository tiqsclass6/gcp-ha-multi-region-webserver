resource "google_compute_health_check" "http_check" {
  name = "http-health-check"

  http_health_check {
    request_path = "/"
    port         = 80
  }

  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
}

resource "google_compute_backend_service" "web_backend" {
  name                  = "web-backend-service"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10

  backend {
    group = google_compute_region_instance_group_manager.mig_iowa.instance_group
  }

  backend {
    group = google_compute_region_instance_group_manager.mig_london.instance_group
  }

  backend {
    group = google_compute_region_instance_group_manager.mig_tokyo.instance_group
  }

  backend {
    group = google_compute_region_instance_group_manager.mig_sao_paulo.instance_group
  }

  health_checks = [google_compute_health_check.http_check.self_link]
}

resource "google_compute_url_map" "web_url_map" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.web_backend.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.web_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name       = "http-forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
}