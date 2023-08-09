resource "google_sql_database" "database" {
  project = "${var.project_id}"
  name     = "ass_database"
  instance = google_sql_database_instance.instance.name
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name             = "database-instance"
  region           = "us-central1"
  project = "${var.project_id}"
  database_version = "POSTGRES_13"
  settings {
    tier              = "db-f1-micro"
    edition           = "ENTERPRISE"
    availability_type = "ZONAL"
  }
  deletion_protection = "false"
}

resource "google_sql_user" "users" {
  name     = "ass_admin"
  project = "${var.project_id}"
  instance = google_sql_database_instance.instance.name
  password = "password"
}