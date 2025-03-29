resource "google_compute_instance_template" "template_iowa1" {
  name         = "web-server-template-iowa1"
  machine_type = "e2-medium"

  lifecycle {
    create_before_destroy = true
  }

  tags = ["http-server"]

  metadata = {
    startup-script = file("${path.module}/startup-script.sh")
    VPC_NAME       = "ha-global-vpc"
  }

  disk {
    auto_delete  = true
    boot         = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet_iowa.id
    access_config {}
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_instance_template" "template_london1" {
  name         = "web-server-template-london1"
  machine_type = "e2-medium"

  lifecycle {
    create_before_destroy = true
  }

  tags = ["http-server"]

  metadata = {
    startup-script = file("${path.module}/startup-script.sh")
    VPC_NAME       = "ha-global-vpc"
  }

  disk {
    auto_delete  = true
    boot         = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet_london.id
    access_config {}
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_instance_template" "template_tokyo1" {
  name         = "web-server-template-tokyo1"
  machine_type = "e2-medium"

  lifecycle {
    create_before_destroy = true
  }

  tags = ["http-server"]

  metadata = {
    startup-script = file("${path.module}/startup-script.sh")
    VPC_NAME       = "ha-global-vpc"
  }

  disk {
    auto_delete  = true
    boot         = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet_tokyo.id
    access_config {}
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_instance_template" "template_sao_paulo1" {
  name         = "web-server-template-sao-paulo1"
  machine_type = "e2-medium"

  lifecycle {
    create_before_destroy = true
  }

  tags = ["http-server"]

  metadata = {
    startup-script = file("${path.module}/startup-script.sh")
    VPC_NAME       = "ha-global-vpc"
  }

  disk {
    auto_delete  = true
    boot         = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet_sao_paulo.id
    access_config {}
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}