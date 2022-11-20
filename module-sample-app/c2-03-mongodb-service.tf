# Resource: Mongo DB Service
resource "kubernetes_service_v1" "mongodb_service" {
  depends_on = [var.sample_app_depends_on]  
  metadata {
    name = "mongodb"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.mongodb_deployment.spec.0.selector.0.match_labels.app 
    }
    port {
      port = 27017 # Service Port
      name = "mongo"
    }
    type = "ClusterIP"
    cluster_ip = "None" # This means we are going to use Pod IP
  }
}