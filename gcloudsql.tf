variable "db_api_username" {
  description = "DB Username for API"
  type        = string
  sensitive   = true
}

variable "db_api_password" {
  description = "DB Password for API"
  type        = string
  sensitive   = true
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name             = "private-instance-${random_id.db_name_suffix.hex}"
  region           = var.region
  database_version = "MYSQL_8_0"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.vpc.id
      enable_private_path_for_google_cloud_services = false
    }
  }

  deletion_protection = false
}

resource "google_sql_user" "user" {
  instance  = google_sql_database_instance.instance.name
  name      = var.db_api_username
  password  = var.db_api_password
  type      = "BUILT_IN"
}

resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}
