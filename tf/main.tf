provider "google" {
  project = "roi-takeoff-user4"
  region  = "us-central1"
  zone    = "us-central1-c"
}

locals {
  location = "us_central"
  service_name   = "go-pets"
  deployment_name = "go-pets"
  pets_worker_sa  = "serviceAccount:${google_service_account.pets_worker.email}"
}

# Create a service account
resource "google_service_account" "pets_worker" {
  account_id   = "pets-worker"
  display_name = "Pets Worker SA"
}

resource "google_service_account_key" "pets_worker_key" {
  service_account_id = google_service_account.pets_worker.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# Set permissions
resource "google_project_iam_binding" "service_permissions" {
  for_each = toset([
    "run.invoker", "datastore.owner","appengine.appAdmin"
  ])
  
  role       = "roles/${each.key}"
  members    = [local.pets_worker_sa]
  depends_on = [google_service_account.pets_worker]
}

resource "google_cloud_run_service" "default" {
  name     = "go-pets"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/roi-takeoff-user4/image10"
      }
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}