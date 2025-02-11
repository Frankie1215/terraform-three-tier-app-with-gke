resource "kubernetes_deployment" "api" {
  metadata {
    name = "api"
    namespace = kubernetes_namespace.app.metadata.0.name
    labels = {
      App = "api"
    }
  }

  spec {
    selector {
      match_labels = {
        App = "api"
      }
    }
    template {
      metadata {
        labels = {
          App = "api"
        }
      }
      spec {
        container {
          image = "nginx:1.24"
          name  = "api"

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

resource "kubernetes_service" "api" {
  metadata {
    name = "api"
    namespace = kubernetes_namespace.app.metadata.0.name
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

resource "kubernetes_horizontal_pod_autoscaler" "api" {
  metadata {
    name      = "api"
    namespace = kubernetes_namespace.app.metadata.0.name
  }

  spec {
    max_replicas = 5
    min_replicas = 1

    target_cpu_utilization_percentage = 60

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "api"
    }
  }
}
