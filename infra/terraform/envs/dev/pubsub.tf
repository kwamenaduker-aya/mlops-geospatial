# MESSAGING & ORCHESTRATION

resource "google_pubsub_topic" "job_queue" {
  name = "${local.name_prefix}-job-queue"
  labels = local.common_tags
}

resource "google_pubsub_subscription" "inference_subscription" {
  name  = "${local.name_prefix}-inference-sub"
  topic = google_pubsub_topic.job_queue.name
  message_retention_duration = "604800s"
  ack_deadline_seconds = 300
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter_queue.id
    max_delivery_attempts = 5
  }
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
}

resource "google_pubsub_topic" "dead_letter_queue" {
  name = "${local.name_prefix}-dead-letter-queue"
  labels = local.common_tags
}

resource "google_pubsub_subscription" "dead_letter_subscription" {
  name  = "${local.name_prefix}-dead-letter-sub"
  topic = google_pubsub_topic.dead_letter_queue.name
  message_retention_duration = "604800s"
}

resource "google_pubsub_topic" "webhook_notifications" {
  name = "${local.name_prefix}-webhook-notifications"
  labels = local.common_tags
}

resource "google_pubsub_subscription" "webhook_subscription" {
  name  = "${local.name_prefix}-webhook-sub"
  topic = google_pubsub_topic.webhook_notifications.name
  ack_deadline_seconds = 60
  retry_policy {
    minimum_backoff = "5s"
    maximum_backoff = "300s"
  }
}
