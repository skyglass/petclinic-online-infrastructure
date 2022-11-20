# Resource: Movies API Service
resource "kubernetes_service_v1" "movies_api_service" {
  depends_on = [var.sample_app_depends_on] 
  metadata {
    name = "movies-api"
    annotations = {
      "alb.ingress.kubernetes.io/healthcheck-path" = "/movies-api/actuator/health"
    }      
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.movies_api_deployment.spec.0.selector.0.match_labels.app
    }
    port {
      name = "http"
      port = 80 # Service Port
      target_port = 80
    }
    port {
      name = "http-mgm"
      port = 4004 # Service Port
      target_port = 4004
    }

    type = "NodePort"
  }
}