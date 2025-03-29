# Allow Google Cloud health check probes
resource "google_compute_firewall" "allow_health_checks" {
  name    = "allow-health-checks"
  network = google_compute_network.vpc_network.name

  direction     = "INGRESS"
  priority      = 2
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["http-server"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  description = "Allow health check probes from Google to port 80"
}

# Allow HTTP traffic from the internet
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  direction     = "INGRESS"
  priority      = 1
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  description = "Allow inbound HTTP traffic on port 80 from anywhere"
}