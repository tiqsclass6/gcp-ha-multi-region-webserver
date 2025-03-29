resource "google_compute_subnetwork" "subnet_iowa" {
  name          = "subnet-iowa"
  ip_cidr_range = "10.230.20.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_london" {
  name          = "subnet-london"
  ip_cidr_range = "10.230.40.0/24"
  region        = "europe-west1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_tokyo" {
  name          = "subnet-tokyo"
  ip_cidr_range = "10.230.60.0/24"
  region        = "asia-northeast1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_sao_paulo" {
  name          = "subnet-sao-paulo"
  ip_cidr_range = "10.230.80.0/24"
  region        = "southamerica-east1"
  network       = google_compute_network.vpc_network.id
}