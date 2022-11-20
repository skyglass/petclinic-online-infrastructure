# Resource: MongoDB Persistent Volume Claim
resource "kubernetes_persistent_volume_claim_v1" "mongodb_pvc" {
  depends_on = [var.sample_app_depends_on]  
  metadata {
    name = "ebs-mongodb-pv-claim"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class_v1.ebs_sc.metadata.0.name 
    resources {
      requests = {
        storage = "2Gi"
      }
    }
  }
}

# Resource: Keycloak Persistent Volume Claim
resource "kubernetes_persistent_volume_claim_v1" "keycloak_pvc" {
  depends_on = [var.sample_app_depends_on]  
  metadata {
    name = "ebs-keycloak-pv-claim"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class_v1.ebs_sc.metadata.0.name 
    resources {
      requests = {
        storage = "2Gi"
      }
    }
  }
}
