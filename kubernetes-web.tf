resource "kubernetes_deployment" "web" {
  metadata {
    name = "web"
    namespace = "app"
    labels = {
      App = "web"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "web"
      }
    }
    template {
      metadata {
        labels = {
          App = "web"
        }
      }
      spec {
        container {
          image = "nginx:1.24"
          name  = "web"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "web" {
  metadata {
    name = "web"
    namespace = "app"
  }
  spec {
    selector = {
      App = kubernetes_deployment.web.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "web" {
  metadata {
    name = "web"
    namespace = "app"
  }

  spec {
      rule {
        http {
         path {
           backend {
             service {
               name = "web"
               port {
                 number = 80
               }
             }
           }
        }
      }
    }
  }
}