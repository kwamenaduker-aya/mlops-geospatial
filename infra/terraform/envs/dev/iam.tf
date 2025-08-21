# SERVICE ACCOUNTS & IAM

resource "google_service_account" "api_service" {
  account_id   = "${local.name_prefix}-api-sa"
  display_name = "MLOps API Service Account"
  description  = "Service account for the MLOps API service"
}

resource "google_service_account" "inference_service" {
  account_id   = "${local.name_prefix}-inference-sa"
  display_name = "MLOps Inference Service Account"
  description  = "Service account for the inference workers"
}

resource "google_service_account" "webhook_service" {
  account_id   = "${local.name_prefix}-webhook-sa"
  display_name = "MLOps Webhook Service Account"
  description  = "Service account for webhook notifications"
}

resource "google_project_iam_member" "api_service_roles" {
  for_each = toset([
    "roles/storage.admin",
    "roles/pubsub.editor",
    "roles/cloudsql.client",
    "roles/secretmanager.secretAccessor"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.api_service.email}"
}

resource "google_project_iam_member" "inference_service_roles" {
  for_each = toset([
    "roles/storage.admin",
    "roles/pubsub.subscriber",
    "roles/pubsub.publisher",
    "roles/cloudsql.client"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.inference_service.email}"
}

resource "google_project_iam_member" "webhook_service_roles" {
  for_each = toset([
    "roles/pubsub.subscriber",
    "roles/storage.objectViewer",
    "roles/secretmanager.secretAccessor"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.webhook_service.email}"
}
