# Resource: Movies UI Kubernetes Deployment
resource "kubernetes_deployment_v1" "movies_ui_deployment" {
  depends_on = [var.sample_app_depends_on] 
  metadata {
    name = "movies-ui"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "movies-ui"
      }          
    }
    template {
      metadata {
        labels = {
          app = "movies-ui"
          version = "v1"
        }
      }
      spec {
        container {
          name = "movies-ui"
          image = "skyglass/movies-ui:1.0.1"
          image_pull_policy = "Always"
          port {
            container_port = 80
          }
          resources {
            requests = {
              memory = "200Mi"
            }
            limits = {
              memory = "400Mi"
            }
          }
        }
      }
    }      
  }  
}