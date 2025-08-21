locals {
  name_prefix = "mlops-geospatial-${var.environment}"
  common_tags = {
    Environment = var.environment
    Project     = "mlops-geospatial-inference"
    ManagedBy   = "terraform"
  }
}
