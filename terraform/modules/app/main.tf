# NAMESPACES
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = terraform.workspace
  }
}

resource "kubernetes_secret" "db_creds" {
  metadata {
    name      = "db-creds"
    namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  # In further will get data from AWS Secrets Manager (Account ID: 635040201264)
  data = {
    mysql_root_password = "root"
    mysql_database = "anketa"
    mysql_user = "user"
    mysql_password = "user"
  }

  type = "Opaque"

  lifecycle {
    ignore_changes = [data]
  }
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "cloud_tech_demo_db" {
  name = "/cloud-tech-demo/frontend/${terraform.workspace}"
}

resource "kubernetes_deployment_v1" "cloud_tech_demo_db" {

  metadata {
    name      = "cloud-tech-demo-db-${terraform.workspace}-${var.project}"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = {
      app = "cloud-tech-demo-db-${terraform.workspace}-${var.project}"
      service = "irc"
      env = terraform.workspace
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "cloud-tech-demo-db-${terraform.workspace}-${var.project}"
        service = "irc"
        env = terraform.workspace
      }
    }
    template {
      metadata {
        labels = {
          app = "cloud-tech-demo-db-${terraform.workspace}-${var.project}"
          service = "irc"
          env = terraform.workspace
        }
      }
      spec {
        container {
          name  = "cloud-tech-demo-db"
          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_rep}:${data.aws_ssm_parameter.cloud_tech_demo_db.value}"
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "db-creds"
                key  = "mysql_root_password"
              }
            }
          }
          env {
            name  = "MYSQL_DATABASE"
            value_from {
              secret_key_ref {
                name = "db-creds"
                key  = "mysql_database"
              }
            }
          }
          env {
            name  = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = "db-creds"
                key  = "mysql_user"
              }
            }
          }
          env {
            name  = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "db-creds"
                key  = "mysql_password"
              }
            }
          }

          port {
            container_port = 3306
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "0.5"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.namespace,
  ]
}

data "aws_ssm_parameter" "cloud_tech_demo_backend" {
  name = "/cloud-tech-demo/backend/${terraform.workspace}"
}

resource "kubernetes_deployment_v1" "cloud_tech_demo_backend" {

  metadata {
    name      = "cloud-tech-demo-backend-${terraform.workspace}-${var.project}"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = {
      app = "cloud-tech-demo-backend-${terraform.workspace}-${var.project}"
      service = "irc"
      env = terraform.workspace
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "cloud-tech-demo-backend-${terraform.workspace}-${var.project}"
        service = "irc"
        env = terraform.workspace
      }
    }
    template {
      metadata {
        labels = {
          app = "cloud-tech-demo-backend-${terraform.workspace}-${var.project}"
          service = "irc"
          env = terraform.workspace
        }
      }
      spec {
        container {
          name  = "cloud-tech-demo-backend"
          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_rep}:${data.aws_ssm_parameter.cloud_tech_demo_backend.value}"

          port {
            container_port = 3000
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "0.5"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.namespace,
  ]
}

data "aws_ssm_parameter" "cloud_tech_demo_frontend" {
  name = "/cloud-tech-demo/frontend/${terraform.workspace}"
}

resource "kubernetes_deployment_v1" "cloud_tech_demo_frontend" {

  metadata {
    name      = "cloud-tech-demo-frontend-${terraform.workspace}-${var.project}"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = {
      app = "cloud-tech-demo-frontend-${terraform.workspace}-${var.project}"
      service = "irc"
      env = terraform.workspace
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "cloud-tech-demo-frontend-${terraform.workspace}-${var.project}"
        service = "irc"
        env = terraform.workspace
      }
    }
    template {
      metadata {
        labels = {
          app = "cloud-tech-demo-frontend-${terraform.workspace}-${var.project}"
          service = "irc"
          env = terraform.workspace
        }
      }
      spec {
        container {
          name  = "cloud-tech-demo-frontend"
          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_rep}:${data.aws_ssm_parameter.cloud_tech_demo_frontend.value}"

          # env {
          #   name  = "BACKEND_URL"
          #   value = "http://${aws_route53_record.backend.name}"
          # }

          port {
            container_port = 3000
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "0.5"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.namespace,
  ]
}

resource "kubernetes_service_v1" "db" {
  metadata {
    name      = "db-${terraform.workspace}-${var.project}"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = {
      app = "cloud-tech-demo-db-${terraform.workspace}-${var.project}"
      service = "irc"
      env = terraform.workspace
    }
  }

  spec {
    selector = {
      app     = "cloud-tech-demo-db-${terraform.workspace}-${var.project}"
      service = "irc"
      env     = terraform.workspace
    }
    port {
      name        = "db"
      protocol    = "TCP"
      port        = 3306
      target_port = 3306
    }
    type = "NodePort"
  }
}

resource "kubernetes_service_v1" "backend" {
  metadata {
    name      = "backend-${terraform.workspace}-${var.project}"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = {
      app = "cloud-tech-demo-backend-${terraform.workspace}-${var.project}"
      service = "irc"
      env = terraform.workspace
    }
  }

  spec {
    selector = {
      app     = "cloud-tech-demo-backend-${terraform.workspace}-${var.project}"
      service = "irc"
      env     = terraform.workspace
    }
    port {
      name        = "backend"
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }
    type = "NodePort"
  }
}

resource "kubernetes_service_v1" "frontend" {
  metadata {
    name      = "frontend-${terraform.workspace}-${var.project}"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = {
      app = "cloud-tech-demo-frontend-${terraform.workspace}-${var.project}"
      service = "irc"
      env = terraform.workspace
    }
  }

  spec {
    selector = {
      app     = "cloud-tech-demo-frontend-${terraform.workspace}-${var.project}"
      service = "irc"
      env     = terraform.workspace
    }
    port {
      name        = "frontend"
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "backend" {
  wait_for_load_balancer = true

  metadata {
    name      = "backend-${terraform.workspace}-${var.project}-port-80"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    annotations = {
      "alb.ingress.kubernetes.io/load-balancer-name" = var.alb_name
      "alb.ingress.kubernetes.io/group.name"         = "stage.group"
      "alb.ingress.kubernetes.io/tags"               = join(",", [for key, value in var.cloud_tech_demo_tags : "${key}=${value}"])
      "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
      "alb.ingress.kubernetes.io/subnets"            = "subnet-00507a1542f873ac5,subnet-09c3673129cdb146c"
      # "alb.ingress.kubernetes.io/security-groups"    = data.aws_security_group.alb.id
      "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTP\": 80}]"
      # "alb.ingress.kubernetes.io/certificate-arn"    = each.value.backend_protocol == "HTTPS" ? data.aws_acm_certificate.cert.arn : ""
      "alb.ingress.kubernetes.io/target-type"        = "ip"
      "alb.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/rewrite-target"   = "/"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "backend.${kubernetes_namespace.namespace.metadata[0].name}.${var.hosted_zone_name}"
      http {
        path {
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service_v1.backend.metadata.0.name
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

resource "kubernetes_ingress_v1" "frontend" {
  wait_for_load_balancer = true

  metadata {
    name      = "frontend-${terraform.workspace}-${var.project}-port-3000"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    annotations = {
      "alb.ingress.kubernetes.io/load-balancer-name" = var.alb_name
      "alb.ingress.kubernetes.io/group.name"         = "stage.group"
      "alb.ingress.kubernetes.io/tags"               = join(",", [for key, value in var.cloud_tech_demo_tags : "${key}=${value}"])
      "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
      "alb.ingress.kubernetes.io/subnets"            = "subnet-00507a1542f873ac5,subnet-09c3673129cdb146c"
      # "alb.ingress.kubernetes.io/security-groups"    = data.aws_security_group.alb.id
      "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTP\": 80}]"
      # "alb.ingress.kubernetes.io/certificate-arn"    = each.value.backend_protocol == "HTTPS" ? data.aws_acm_certificate.cert.arn : ""
      "alb.ingress.kubernetes.io/target-type"        = "ip"
      "alb.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/rewrite-target"   = "/"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "irc.${kubernetes_namespace.namespace.metadata[0].name}.${var.hosted_zone_name}"
      http {
        path {
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service_v1.frontend.metadata.0.name
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

data "aws_route53_zone" "cloud_tech_demo" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "backend" {
  allow_overwrite = true
  name            = "backend.${kubernetes_namespace.namespace.metadata[0].name}.${var.hosted_zone_name}"
  records         = ["${var.alb_name}.${var.region}.${var.hosted_zone_name}"]
  ttl             = 60
  type            = "CNAME"
  zone_id         = data.aws_route53_zone.cloud_tech_demo.zone_id
}

resource "aws_route53_record" "frontend" {
  allow_overwrite = true
  name            = "irc.${kubernetes_namespace.namespace.metadata[0].name}.${var.hosted_zone_name}"
  records         = ["${var.alb_name}.${var.region}.${var.hosted_zone_name}"]
  ttl             = 60
  type            = "CNAME"
  zone_id         = data.aws_route53_zone.cloud_tech_demo.zone_id
}




