resource "google_service_account" "k8s-staging" {
  project    = var.project_id
  account_id = "k8s-acc"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "gke" {
  name     = "ass-prod-cluster"
  location = "us-central1-a"
  project  = var.project_id

  networking_mode = "VPC_NATIVE"
  network         = google_compute_network.main.self_link
  subnetwork      = google_compute_subnetwork.private.self_link

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ip-range"
    services_secondary_range_name = "services-ip-range"
  }

  network_policy {
    provider = "PROVIDER_UNSPECIFIED"
    enabled  = true
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

}

resource "google_container_node_pool" "general" {
  name       = "general"
  location   = "us-central1-a"
  cluster    = google_container_cluster.gke.name
  project    = var.project_id
  node_count = 2

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 2 
  }

  node_config {
    labels = {
      role = "general"
    }
    machine_type = "n1-standard-2"
    disk_size_gb = 50

    service_account = google_service_account.k8s-staging.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}