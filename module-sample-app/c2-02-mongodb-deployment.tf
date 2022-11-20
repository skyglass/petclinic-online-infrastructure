# Resource: Mongo DB Kubernetes Deployment
resource "kubernetes_deployment_v1" "mongodb_deployment" {
  depends_on = [var.sample_app_depends_on]
  metadata {
    name = "mongodb"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mongodb"
      }          
    }
    strategy {
      type = "Recreate"
    }  
    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }
      spec {
        volume {
          name = "mongodb-persistent-storage"
          persistent_volume_claim {
            #claim_name = kubernetes_persistent_volume_claim_v1.pvc.metadata.0.name # THIS IS NOT GOING WORK, WE NEED TO GIVE PVC NAME DIRECTLY OR VIA VARIABLE, direct resource name reference will fail.
            claim_name = "ebs-mongodb-pv-claim"
          }
        }
        container {
          name = "mongodb"
          image = "mongo:5.0.9"
          port {
            container_port = 27017
          }
          env_from {
            secret_ref {
              name = kubernetes_secret_v1.mongodb_server_credentials.metadata.0.name
            }
          }
          volume_mount {
            name = "mongodb-persistent-storage"
            mount_path = "/var/lib/mongodb"
          }
          resources {            
            limits = {
              memory = "350Mi"
            }
          }
        }
      }
    }      
  }
  
}