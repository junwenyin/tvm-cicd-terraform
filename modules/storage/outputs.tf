output "input_bucket" {
  value       = google_storage_bucket.input_bucket.name
  description = "tvm input bucket"
}

output "output_bucket" {
  value       = google_storage_bucket.output_bucket.name
  description = "tvm output bucket"
}

output "function_bucket" {
  value       = google_storage_bucket.function_bucket.name
  description = "cloud function tmp bucket"
}