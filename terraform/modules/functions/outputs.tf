output "process_audio_function_name" {
  description = "Name of the process audio function"
  value = var.process_audio_function_name
}

output "process_audio_function_url" {
  description = "URL of the process audio function"
  value       = google_cloudfunctions2_function.process_audio_function.service_config[0].uri
}