module "storage" {
  source = "./modules/storage"
  audio_bucket_name    = "sonicscribe-audio"
  function_bucket_name = "sonicscribe-functions"
  project_id           = var.project_id
  region               = var.region
}

module "iam" {
  source = "./modules/iam"
  project_id = var.project_id
  service_account_email = google_service_account.cloud_function_service_account.email
}

resource "google_service_account" "cloud_function_service_account" {
  account_id   = "sonicscribe-cloud-function-sa"
  display_name = "Cloud Function Service Account for SonicScribe"
  project      = var.project_id
}

module "functions" {
  source = "./modules/functions"

  audio_bucket_name                   = module.storage.audio_bucket_name
  function_bucket_name                = module.storage.function_bucket_name
  process_audio_function_name         = "process_audio"
  process_audio_function_entry_point  = "process_audio"
  process_audio_function_archive_name = "process_audio"
  process_audio_function_source_dir   = "../functions/process_audio"
  process_audio_function_output_path  = "../functions/process_audio.zip"
  process_audio_function_runtime      = "python312"
  project_id                          = var.project_id
  region                              = var.region
  service_account_email               = google_service_account.cloud_function_service_account.email

  depends_on = [google_service_account.cloud_function_service_account]
}
