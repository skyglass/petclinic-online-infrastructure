 # Resource: Mongo DB Server Secret
resource "kubernetes_secret_v1" "mongodb_server_credentials" {
  depends_on = [var.sample_app_depends_on]
   metadata {
     name = "mongodb-server-credentials"
   }
   type = "Opaque"
   data = {
     "MONGO_INITDB_ROOT_USERNAME" = "mongodb-user-dev"
     "MONGO_INITDB_ROOT_PASSWORD" = "mongodb-pwd-dev"
   }
} 

# Resource: Mongo DB Secret
resource "kubernetes_secret_v1" "mongodb_credentials" {
   depends_on = [var.sample_app_depends_on]
   metadata {
     name = "mongodb-credentials"
   }
   type = "Opaque"
   data = {
     "SPRING_DATA_MONGODB_AUTHENTICATION_DATABASE" = "admin"
     "SPRING_DATA_MONGODB_USERNAME" = "mongodb-user-dev"
     "SPRING_DATA_MONGODB_PASSWORD" = "mongodb-pwd-dev"
   }
}