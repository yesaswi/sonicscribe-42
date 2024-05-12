resource "google_project_iam_member" "cloud_function_service_account_roles" {
  for_each = toset([
    "roles/cloudfunctions.admin",
    "roles/storage.objectAdmin",
    # Add other required roles
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${var.service_account_email}"
}
