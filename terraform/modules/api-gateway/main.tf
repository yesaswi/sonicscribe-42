resource "google_api_gateway_api" "sonicscribe_api" {
  provider = google-beta
  api_id = var.api_id
  project = var.project_id
}

data "template_file" "openapi_spec" {
  template = file(var.openapi_spec_path)

  vars = {
    process_audio_function_url = var.process_audio_function_url
  }
}

resource "google_api_gateway_api_config" "sonicscribe_api_config" {
  provider = google-beta
  api = google_api_gateway_api.sonicscribe_api.api_id
  api_config_id = var.api_config_id
  project = var.project_id

  openapi_documents {
    document {
      path = var.openapi_spec_path
      contents = base64encode(data.template_file.openapi_spec.rendered)
    }
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
  project = var.project_id
  region = var.region
}
