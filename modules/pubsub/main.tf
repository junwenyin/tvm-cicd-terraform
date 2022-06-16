resource "google_pubsub_topic" "tvm_job_submit_topic" {
  name    = "tvm-job-submit-topic"
  project = "${var.project_id}"
}

resource "google_pubsub_topic" "tvm_job_clean_topic" {
  name    = "tvm-job-clean-topic"
  project = "${var.project_id}"
}

resource "google_pubsub_topic_iam_member" "member" {
  project = google_pubsub_topic.tvm_job_clean_topic.project
  topic = google_pubsub_topic.tvm_job_clean_topic.name
  role = "roles/pubsub.publisher"
  member = "serviceAccount:tvm-job-runner@${var.project_id}.iam.gserviceaccount.com"
}