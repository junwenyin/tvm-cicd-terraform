output "tvm_job_submit_topic" {
  value       = google_pubsub_topic.tvm_job_submit_topic.name
  description = "tvm job submit topic"
}

output "tvm_job_clean_topic" {
  value       = google_pubsub_topic.tvm_job_clean_topic.name
  description = "tvm job clean topic"
}