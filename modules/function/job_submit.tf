# zip up our source code
data "archive_file" "submit_function_zip" {
  type        = "zip"
  source_dir  = "../../src/tvm-job-submit/"
  output_path = "/tmp/tvm-job-submit.zip"
}


resource "google_storage_bucket_object" "submit_archive" {
  source = data.archive_file.submit_function_zip.output_path
  content_type = "application/zip"

  # Append to the MD5 checksum of the files's content
  # to force the zip to be updated as soon as a change occurs
  name = "src-${data.archive_file.submit_function_zip.output_md5}.zip"
  bucket = var.function_tmp_bucket
}

# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "tvm_job_submit_function" {
  name = "tvm-job-submit-trigger-on-pubsub"
  runtime = "python39"  # of course changeable

  # Get the source code of the cloud function as a Zip compression
  source_archive_bucket = var.function_tmp_bucket
  source_archive_object = google_storage_bucket_object.submit_archive.name

  # Must match the function name in the cloud function `main.py` source code
  entry_point           = "hello_pubsub"
  
  # 
  event_trigger {
      event_type = "google.pubsub.topic.publish"
      resource   = var.submit_function_trigger_topic
  }
}