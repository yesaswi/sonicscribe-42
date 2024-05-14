variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "api_id" {
  description = "The ID of the API"
  type        = string
}

variable "api_config_id_prefix" {
  description = "The prefix for the ID of the API config"
  type        = string
}

variable "openapi_spec_path" {
  description = "The path to the OpenAPI specification file"
  type        = string
}

variable "service_account_email" {
  description = "The email address of the service account"
  type        = string
}

variable "gateway_id" {
  description = "The ID of the API Gateway"
  type        = string
}

variable "process_audio_function_url" {
  description = "The URL of the process_audio Cloud Function"
  type        = string
}
