# STORAGE INFRASTRUCTURE

resource "google_storage_bucket" "input_data" {
  name     = "${local.name_prefix}-input-data-${random_id.suffix.hex}"
  location = var.region
  storage_class = "STANDARD"
  versioning { enabled = true }
  lifecycle_rule {
    condition { age = 30 }
    action { type = "Delete" }
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  labels = local.common_tags
}

resource "google_storage_bucket" "output_results" {
  name     = "${local.name_prefix}-output-results-${random_id.suffix.hex}"
  location = var.region
  storage_class = "STANDARD"
  versioning { enabled = true }
  lifecycle_rule {
    condition { age = 90 }
    action { type = "Delete" }
  }
  labels = local.common_tags
}

resource "google_storage_bucket" "model_artifacts" {
  name     = "${local.name_prefix}-model-artifacts-${random_id.suffix.hex}"
  location = var.region
  storage_class = "STANDARD"
  versioning { enabled = false }
  labels = local.common_tags
}

resource "google_storage_bucket_iam_binding" "input_data_access" {
  bucket = google_storage_bucket.input_data.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.api_service.email}",
    "serviceAccount:${google_service_account.inference_service.email}"
  ]
}

resource "google_storage_bucket_iam_binding" "output_results_access" {
  bucket = google_storage_bucket.output_results.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.api_service.email}",
    "serviceAccount:${google_service_account.inference_service.email}"
  ]
}
