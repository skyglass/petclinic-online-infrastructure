 # Resource: Keycloak Secret
resource "kubernetes_secret_v1" "keycloak_secret" {
  depends_on = [var.sample_app_depends_on]  
   metadata {
     name = "keycloak"
   }
   type = "Opaque"
   data = {
     "KEYCLOAK_PASSWORD" = "bXkta2V5Y2xvYWstcGFzc3dvcmQ="
     "KEYCLOAK_MGMT_PASSWORD" = "bXkta2V5Y2xvYWstcGFzc3dvcmQ="
   }
}