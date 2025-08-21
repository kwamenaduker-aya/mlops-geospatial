# MONITORING & LOGGING

resource "google_logging_project_sink" "audit_logs" {
  name        = "${local.name_prefix}-audit-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.audit_logs.name}"
  filter = "protoPayload.serviceName=\"compute.googleapis.com\" OR protoPayload.serviceName=\"container.googleapis.com\""
  unique_writer_identity = true
}

resource "google_storage_bucket" "audit_logs" {
  name     = "${local.name_prefix}-audit-logs-${random_id.suffix.hex}"
  location = var.region
  storage_class = "NEARLINE"
  lifecycle_rule {
    condition { age = 365 }
    action { type = "Delete" }
  }
  labels = local.common_tags
}

resource "google_storage_bucket_iam_binding" "audit_logs_sink" {
  bucket = google_storage_bucket.audit_logs.name
  role   = "roles/storage.objectCreator"
  members = [
    google_logging_project_sink.audit_logs.writer_identity
  ]
}
