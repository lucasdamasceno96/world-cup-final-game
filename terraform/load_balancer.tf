# terraform/load_balancer.tf

# Serverless Network Endpoint Group (NEG) pointing to the Cloud Run service.
# This allows the Load Balancer to route traffic directly to Cloud Run 
# without needing an intermediate compute layer (like GKE or GCE).
resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "ticketing-api-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = google_cloud_run_v2_service.ticketing_api.name
  }
}

# Global External HTTP Load Balancer components.
# A global LB is used here to provide a single anycast IP for the application.
# This setup is foundational for future integration with Cloud Armor 
# (to block scalper bots and DDoS attacks) and Cloud CDN (for caching static assets).

# 1. Backend Service
resource "google_compute_backend_service" "lb_backend" {
  name      = "ticketing-api-backend"
  protocol  = "HTTP"
  port_name = "http"
  timeout_sec = 30

  # Connect the backend to the Serverless NEG
  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }

  # Health check pointing to our FastAPI /health endpoint
  health_checks = [google_compute_health_check.lb_health_check.id]
}

# 2. Health Check
resource "google_compute_health_check" "lb_health_check" {
  name = "ticketing-api-health-check"

  http_health_check {
    port         = 8080
    request_path = "/health"
  }
}

# 3. URL Map (Routing)
resource "google_compute_url_map" "lb_url_map" {
  name            = "ticketing-api-url-map"
  default_service = google_compute_backend_service.lb_backend.id
}

# 4. Target HTTP Proxy
resource "google_compute_target_http_proxy" "lb_http_proxy" {
  name    = "ticketing-api-http-proxy"
  url_map = google_compute_url_map.lb_url_map.id
}

# 5. Global Forwarding Rule (Port 80)
resource "google_compute_global_forwarding_rule" "lb_forwarding_rule" {
  name       = "ticketing-api-forwarding-rule"
  target     = google_compute_target_http_proxy.lb_http_proxy.id
  port_range = "80"
  ip_protocol = "TCP"
}