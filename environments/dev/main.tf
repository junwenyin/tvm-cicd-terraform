# Configure the Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}

module "storage" {
  source       = "../../modules/storage"
  project_id = var.project_id
  location     = var.location
  region       = var.region
  zone         = var.zone
  env          = var.env
}

module "pubsub" {
  source       = "../../modules/pubsub"
  project_id = var.project_id
  location     = var.location
  region       = var.region
  zone         = var.zone
  env          = var.env
}

module "function" {
  source       = "../../modules/function"
  project_id = var.project_id
  region       = var.region
  zone         = var.zone
  env          = var.env
  function_tmp_bucket = module.storage.function_bucket
  submit_function_trigger_bucket = module.storage.input_bucket
  clean_function_trigger_bucket = module.storage.output_bucket
  submit_function_trigger_topic = module.pubsub.tvm_job_submit_topic
  clean_function_trigger_topic = module.pubsub.tvm_job_clean_topic
}
