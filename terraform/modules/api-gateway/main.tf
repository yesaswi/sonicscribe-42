resource "google_api_gateway_api" "sonicscribe_api" {
  provider = google-beta
  api_id = var.api_id
  project = var.project_id
  display_name = "Sonicscribe API"
}

resource "google_api_gateway_api_config" "sonicscribe_api_config" {
  provider = google-beta
  api = google_api_gateway_api.sonicscribe_api.api_id
  api_config_id_prefix = var.api_config_id_prefix
  project = var.project_id
  display_name = "Sonicscribe API Config"

  openapi_documents {
    document {
      path = var.openapi_spec_path
      contents = base64encode(templatefile(var.openapi_spec_path, {
        process_audio_function_url = var.process_audio_function_url
      }))
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  gateway_config {
    backend_config {
      google_service_account = var.service_account_email
    }
  }
}

resource "google_api_gateway_gateway" "sonicscribe_gateway" {
  provider = google-beta
  api_config = google_api_gateway_api_config.sonicscribe_api_config.id
  gateway_id = var.gateway_id
  display_name = "Sonicscribe Gateway"
  project = var.project_id
  region = var.region

  depends_on = [google_api_gateway_api_config.sonicscribe_api_config]
}
