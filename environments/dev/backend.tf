terraform {
  backend "gcs" {
    bucket  = "gnomondigital-sandbox-tf-state-dev"
    prefix  = "ai-platform/terraform/state"
  }
}