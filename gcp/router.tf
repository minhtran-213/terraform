resource "google_compute_router" "router" {
  name    = "router"
  region  = local.region
  project = var.project_id
  network = google_compute_network.main.self_link
}