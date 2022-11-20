 # Resource: Keycloak Config Map
resource "kubernetes_config_map_v1" "keycloak_config_map" {
  depends_on = [var.sample_app_depends_on]  
  metadata {
    name = "keycloak"
  }
  data = {
    "KEYCLOAK_ADMIN" = "admin"
    "KEYCLOAK_ADMIN_PASSWORD" = "admin"
    "KEYCLOAK_USER" = "admin@keycloak"
    "KEYCLOAK_MGMT_USER" = "mgmt@keycloak"
    "JAVA_OPTS_APPEND" = "-Djboss.http.port=80"
    "KEYCLOAK_LOGLEVEL" = "INFO"
    "ROOT_LOGLEVEL" = "INFO"
    "DB_VENDOR" = "H2"
  # "KC_DB" = "H2"  
    "KC_HTTP_ENABLED" = true
    "KC_HOSTNAME" = "movie.greeta.net"
    "KC_HOSTNAME_PORT" = 443
    "KC_HOSTNAME_STRICT" = false
    "KC_HOSTNAME_STRICT_BACKCHANNEL" = false
    "KC_HOSTNAME_STRICT_HTTPS" = false
    "KC_PROXY" = "edge"
    "KC_FEATURES" = "token-exchange"    
    "KC_PROXY_ADDRESS_FORWARDING" = true
    "PROXY_ADDRESS_FORWARDING" = true
    "KEYCLOAK_FRONTEND_URL" = "https://movie.greeta.net"
    "KEYCLOAK_ADMIN_URL" = "https://movie.greeta.net"
    "KC_HOSTNAME_ADMIN_URL" = "https://movie.greeta.net"
  #  "KC_HOSTNAME_PATH" = "/"
   
  }
}