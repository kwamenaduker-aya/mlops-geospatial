# SECRET MANAGEMENT

resource "google_secret_manager_secret" "db_password" {
  secret_id = "${local.name_prefix}-db-password"
  replication { auto {} }
  labels = local.common_tags
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

resource "google_secret_manager_secret" "api_keys" {
  secret_id = "${local.name_prefix}-api-keys"
  replication { auto {} }
  labels = local.common_tags
}
