# Resource: Movies API Kubernetes Deployment
resource "kubernetes_deployment_v1" "movies_api_deployment" {
  depends_on = [var.sample_app_depends_on] 
  metadata {
    name = "movies-api"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "movies-api"
      }          
    }
    template {
      metadata {
        labels = {
          app = "movies-api"
          version = "v1"
        }
      }
      spec {
        volume {
          name = "movies-api-config-repo"
          config_map {
            name = kubernetes_config_map_v1.movies_api_config_map.metadata.0.name
          }
        }
        container {
          name = "movies-api"
          image = "skyglass/movies-api:1.0.1"
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }
          env {
            name = "SPRING_PROFILES_ACTIVE"
            value = "docker"
          }
          env {
            name = "SPRING_CONFIG_LOCATION"
            value = "file:/config-repo/movies-api.yml"
          }
          env_from {
            secret_ref {
              name = kubernetes_secret_v1.mongodb_credentials.metadata.0.name
            }
          }
          volume_mount {
            name = "movies-api-config-repo"
            mount_path = "/config-repo"
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