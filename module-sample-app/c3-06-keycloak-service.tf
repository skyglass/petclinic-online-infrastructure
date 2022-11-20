# Resource: Keycloak Service
resource "kubernetes_service_v1" "keycloak_service" {
  depends_on = [var.sample_app_depends_on]  
  metadata {
    name = "keycloak"
    annotations = {
      "alb.ingress.kubernetes.io/healthcheck-path" = "/"
    }         
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.keycloak_deployment.spec.0.selector.0.match_labels.app  
    }
    port {
      name = "http"
      port = 8080 # Service Port
      target_port = 8080
    }

    type = "NodePort"
  }
}