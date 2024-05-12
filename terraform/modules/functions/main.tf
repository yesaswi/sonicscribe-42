data "archive_file" "process_audio_function_source" {
  type        = "zip"
  source_dir  = var.process_audio_function_source_dir
  output_path = var.process_audio_function_output_path
}

resource "google_storage_bucket_object" "process_audio_function_archive" {
  name   = "${var.process_audio_function_archive_name}-${data.archive_file.process_audio_function_source.output_md5}.zip"
  bucket = var.function_bucket_name
  source = data.archive_file.process_audio_function_source.output_path
}

resource "google_cloudfunctions2_function" "process_audio_function" {
  name        = var.process_audio_function_name
  location    = var.region
  description = "Cloud function to process audio files"

  build_config {
    runtime     = var.process_audio_function_runtime
    entry_point = var.process_audio_function_entry_point
    source {
      storage_source {
        bucket = var.function_bucket_name
        object = google_storage_bucket_object.process_audio_function_archive.name
      }
    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
    service_account_email = var.service_account_email
    environment_variables = {
        AUDIO_BUCKET_NAME = var.audio_bucket_name
        OPENAI_API_KEY    = var.openai_api_key
    }
  }
}
