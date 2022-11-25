# Resource: Movies API Service
resource "kubernetes_service_v1" "petclinic_online_service" {
  depends_on = [var.sample_app_depends_on] 
  metadata {
    name = "petclinic-online"
    annotations = {
      "alb.ingress.kubernetes.io/healthcheck-path" = "/actuator/health"
    }      
  }
  spec {
    selector = {
      app = "petclinic-online"
    }
    port {
      name = "http"
      port = 80 # Service Port
      target_port = 8080
    }

    type = "NodePort"
  }
}