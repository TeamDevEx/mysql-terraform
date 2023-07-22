resource "google_sql_database_instance" "instance" {

  name             = "my-instance"
  database_version = "MYSQL_5_7"
  region           = "northamerica-northeast1"
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = false

}

resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "user" {
  name     = "my-user"
  instance = google_sql_database_instance.instance.name
  password = "root"
  host     = "180.191.66.152"
}

resource "google_compute_firewall" "firewall" {
  name    = "my-firewall-rule"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3306"] # Adjust the port if needed
  }

  source_ranges = [google_sql_user.user.host]
}
