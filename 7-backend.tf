resource "google_compute_region_instance_group_manager" "mig_iowa" {
  name               = "mig-iowa"
  region             = "us-central1"
  base_instance_name = "web-iowa"

  version {
    instance_template = google_compute_instance_template.template_iowa1.self_link
  }

  target_size = 2
}

resource "google_compute_region_instance_group_manager" "mig_london" {
  name               = "mig-london"
  region             = "europe-west2"
  base_instance_name = "web-london"

  version {
    instance_template = google_compute_instance_template.template_london1.self_link
  }

  target_size = 2
}

resource "google_compute_region_instance_group_manager" "mig_tokyo" {
  name               = "mig-tokyo"
  region             = "asia-northeast1"
  base_instance_name = "web-tokyo"

  version {
    instance_template = google_compute_instance_template.template_tokyo1.self_link
  }

  target_size = 2
}

resource "google_compute_region_instance_group_manager" "mig_sao_paulo" {
  name               = "mig-sao-paulo"
  region             = "southamerica-east1"
  base_instance_name = "web-sao-paulo"

  version {
    instance_template = google_compute_instance_template.template_sao_paulo1.self_link
  }

  target_size = 2
}

resource "google_compute_region_autoscaler" "autoscaler_iowa" {
  name   = "autoscaler-iowa"
  region = "us-central1"
  target = google_compute_region_instance_group_manager.mig_iowa.self_link

  autoscaling_policy {
    min_replicas = 2
    max_replicas = 5
    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_region_autoscaler" "autoscaler_london" {
  name   = "autoscaler-london"
  region = "europe-west2"
  target = google_compute_region_instance_group_manager.mig_london.self_link

  autoscaling_policy {
    min_replicas = 2
    max_replicas = 5
    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_region_autoscaler" "autoscaler_tokyo" {
  name   = "autoscaler-tokyo"
  region = "asia-northeast1"
  target = google_compute_region_instance_group_manager.mig_tokyo.self_link

  autoscaling_policy {
    min_replicas = 2
    max_replicas = 5
    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_region_autoscaler" "autoscaler_sao_paulo" {
  name   = "autoscaler-sao-paulo"
  region = "southamerica-east1"
  target = google_compute_region_instance_group_manager.mig_sao_paulo.self_link

  autoscaling_policy {
    min_replicas = 2
    max_replicas = 5
    cpu_utilization {
      target = 0.6
    }
  }
}