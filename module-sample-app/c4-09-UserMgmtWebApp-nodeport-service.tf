# Resource: Kubernetes Service Manifest (Type: NodePort)
resource "kubernetes_service_v1" "usermgmt_np_service" {
  metadata {
    name = "usermgmt-webapp-nodeport-service"
    annotations = {
      "alb.ingress.kubernetes.io/healthcheck-path" = "/index.html"
    }    
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.usermgmt_webapp.spec.0.selector.0.match_labels.app
    }
    port {
      name        = "http"
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}