 # Resource: Movies API Config Map
 resource "kubernetes_config_map_v1" "movies_api_config_map" {
  depends_on = [var.sample_app_depends_on]  
  metadata {
     name = "movies-api-config-repo"
   }
   data = {
    "movies-api.yml" = "${file("${path.module}/config-repo/movies-api.yml")}"
  }
 } 