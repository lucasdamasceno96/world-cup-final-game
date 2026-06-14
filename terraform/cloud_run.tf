# terraform/cloud_run.tf

# Google Cloud Run service for the ticketing API.
# Cloud Run is chosen for its ability to scale instantly from zero to thousands 
# of instances, which is critical for handling the massive, sudden traffic 
# spikes during a World Cup ticket drop event (2M concurrent users).
resource "google_cloud_run_v2_service" "ticketing_api" {
  name     = "ticketing-api"
  location = var.region

  template {
    containers {
      # Placeholder image. In a real CI/CD pipeline, this would be the built artifact.
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      
      # Resource limits to ensure predictable scaling and cost control under load
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }

      # Cloud Run requires the container to listen on port 8080
      ports {
        container_port = 8080
      }
    }

    # High max instance limit to accommodate ticket drop traffic spikes
    scaling {
      max_instance_count = 1000
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

# IAM policy to allow public (unauthenticated) access to the Cloud Run service.
# Security (rate limiting, bot protection) will be handled at the Load Balancer level.
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  location = google_cloud_run_v2_service.ticketing_api.location
  project  = google_cloud_run_v2_service.ticketing_api.project
  name     = google_cloud_run_v2_service.ticketing_api.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}