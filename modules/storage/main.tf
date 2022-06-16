resource "google_storage_bucket" "function_bucket" {
    name     = "${var.project_id}-function"
    location = var.location
    force_destroy = true
}

resource "google_storage_bucket" "input_bucket" {
    name     = "${var.project_id}-tvm-job-input"
    location = var.location
    force_destroy = true
}

resource "google_storage_bucket" "output_bucket" {
    name     = "${var.project_id}-tvm-job-output"
    location = var.location
    force_destroy = true
}