data "aws_eks_cluster" "cloud_tech_demo" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cloud_tech_demo" {
  name = var.cluster_name
}

# # NAMESPACES
# resource "kubernetes_namespace" "namespace" {
#   metadata {
#     name = var.env
#   }
# }

# resource "kubernetes_secret" "db_creds" {
#   metadata {
#     name      = "db-creds"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#   }

#   # In further will get data from AWS Secrets Manager (Account ID: 635040201264)
#   data = {
#     mysql_root_password = "root"
#     mysql_database = "anketa"
#     mysql_user = "user"
#     mysql_password = "user"
#   }

#   type = "Opaque"

#   lifecycle {
#     ignore_changes = [data]
#   }
# }

# resource "kubernetes_deployment_v1" "cloud_tech_demo_db" {

#   metadata {
#     name      = "cloud-tech-demo-db-${var.env}-${var.project}"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#     labels = {
#       app = "cloud-tech-demo-db-${var.env}-${var.project}"
#       service = "irc"
#       env = var.env
#     }
#   }

#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         app = "cloud-tech-demo-db-${var.env}-${var.project}"
#         service = "irc"
#         env = var.env
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "cloud-tech-demo-db-${var.env}-${var.project}"
#           service = "irc"
#           env = var.env
#         }
#       }
#       spec {
#         container {
#           name  = "cloud-tech-demo-db"
#           image = "196123732812.dkr.ecr.us-east-1.amazonaws.com/cloud-tech-demo:cloud-tech-demo-db"
#           env {
#             name  = "MYSQL_ROOT_PASSWORD"
#             value_from {
#               secret_key_ref {
#                 name = "db-creds"
#                 key  = "mysql_root_password"
#               }
#             }
#           }
#           env {
#             name  = "MYSQL_DATABASE"
#             value_from {
#               secret_key_ref {
#                 name = "db-creds"
#                 key  = "mysql_database"
#               }
#             }
#           }
#           env {
#             name  = "MYSQL_USER"
#             value_from {
#               secret_key_ref {
#                 name = "db-creds"
#                 key  = "mysql_user"
#               }
#             }
#           }
#           env {
#             name  = "MYSQL_PASSWORD"
#             value_from {
#               secret_key_ref {
#                 name = "db-creds"
#                 key  = "mysql_password"
#               }
#             }
#           }

#           port {
#             container_port = 3306
#             protocol       = "TCP"
#           }

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#           }
#         }
#       }
#     }
#   }

#   depends_on = [
#     kubernetes_namespace.namespace,
#   ]
# }

# resource "kubernetes_deployment_v1" "cloud_tech_demo_backend" {

#   metadata {
#     name      = "cloud-tech-demo-backend-${var.env}-${var.project}"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#     labels = {
#       app = "cloud-tech-demo-backend-${var.env}-${var.project}"
#       service = "irc"
#       env = var.env
#     }
#   }

#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         app = "cloud-tech-demo-backend-${var.env}-${var.project}"
#         service = "irc"
#         env = var.env
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "cloud-tech-demo-backend-${var.env}-${var.project}"
#           service = "irc"
#           env = var.env
#         }
#       }
#       spec {
#         container {
#           name  = "cloud-tech-demo-backend"
#           image = "196123732812.dkr.ecr.us-east-1.amazonaws.com/cloud-tech-demo:cloud-tech-demo-backend"

#           port {
#             container_port = 3000
#             protocol       = "TCP"
#           }

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#           }
#         }
#       }
#     }
#   }

#   depends_on = [
#     kubernetes_namespace.namespace,
#   ]
# }

# resource "kubernetes_deployment_v1" "cloud_tech_demo_frontend" {

#   metadata {
#     name      = "cloud-tech-demo-frontend-${var.env}-${var.project}"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#     labels = {
#       app = "cloud-tech-demo-frontend-${var.env}-${var.project}"
#       service = "irc"
#       env = var.env
#     }
#   }

#   spec {
#     replicas = 1
#     selector {
#       match_labels = {
#         app = "cloud-tech-demo-frontend-${var.env}-${var.project}"
#         service = "irc"
#         env = var.env
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "cloud-tech-demo-frontend-${var.env}-${var.project}"
#           service = "irc"
#           env = var.env
#         }
#       }
#       spec {
#         container {
#           name  = "cloud-tech-demo-frontend"
#           image = "196123732812.dkr.ecr.us-east-1.amazonaws.com/cloud-tech-demo:cloud-tech-demo-frontend"

#           # env {
#           #   name  = "BACKEND_URL"
#           #   value = "http://${aws_route53_record.backend.name}"
#           # }

#           port {
#             container_port = 3000
#             protocol       = "TCP"
#           }

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#           }
#         }
#       }
#     }
#   }

#   depends_on = [
#     kubernetes_namespace.namespace,
#   ]
# }

# resource "kubernetes_service_v1" "db" {
#   metadata {
#     name      = "db-${var.env}-${var.project}"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#     labels = {
#       app = "cloud-tech-demo-db-${var.env}-${var.project}"
#       service = "irc"
#       env = var.env
#     }
#   }

#   spec {
#     selector = {
#       app     = "cloud-tech-demo-db-${var.env}-${var.project}"
#       service = "irc"
#       env     = var.env
#     }
#     port {
#       name        = "db"
#       protocol    = "TCP"
#       port        = 3306
#       target_port = 3306
#     }
#     type = "NodePort"
#   }
# }

# resource "kubernetes_service_v1" "backend" {
#   metadata {
#     name      = "backend-${var.env}-${var.project}"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#     labels = {
#       app = "cloud-tech-demo-backend-${var.env}-${var.project}"
#       service = "irc"
#       env = var.env
#     }
#   }

#   spec {
#     selector = {
#       app     = "cloud-tech-demo-backend-${var.env}-${var.project}"
#       service = "irc"
#       env     = var.env
#     }
#     port {
#       name        = "backend"
#       protocol    = "TCP"
#       port        = 80
#       target_port = 3000
#     }
#     type = "NodePort"
#   }
# }

# resource "kubernetes_service_v1" "frontend" {
#   metadata {
#     name      = "frontend-${var.env}-${var.project}"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#     labels = {
#       app = "cloud-tech-demo-frontend-${var.env}-${var.project}"
#       service = "irc"
#       env = var.env
#     }
#   }

#   spec {
#     selector = {
#       app     = "cloud-tech-demo-frontend-${var.env}-${var.project}"
#       service = "irc"
#       env     = var.env
#     }
#     port {
#       name        = "frontend"
#       protocol    = "TCP"
#       port        = 80
#       target_port = 3000
#     }
#     type = "NodePort"
#   }
# }

# resource "kubernetes_ingress_v1" "backend" {
#   wait_for_load_balancer = true

#   metadata {
#     name      = "backend-${var.env}-${var.project}-port-80"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#     annotations = {
#       "alb.ingress.kubernetes.io/load-balancer-name" = var.alb_name
#       "alb.ingress.kubernetes.io/group.name"         = "stage.group"
#       "alb.ingress.kubernetes.io/tags"               = join(",", [for key, value in var.cloud_tech_demo_tags : "${key}=${value}"])
#       "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
#       "alb.ingress.kubernetes.io/subnets"            = "subnet-00507a1542f873ac5,subnet-09c3673129cdb146c"
#       # "alb.ingress.kubernetes.io/security-groups"    = data.aws_security_group.alb.id
#       "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTP\": 80}]"
#       # "alb.ingress.kubernetes.io/certificate-arn"    = each.value.backend_protocol == "HTTPS" ? data.aws_acm_certificate.cert.arn : ""
#       "alb.ingress.kubernetes.io/target-type"        = "ip"
#       "alb.ingress.kubernetes.io/backend-protocol"   = "HTTP"
#       "nginx.ingress.kubernetes.io/rewrite-target"   = "/"
#     }
#   }

#   spec {
#     ingress_class_name = "alb"
#     rule {
#       host = "backend.${kubernetes_namespace.namespace.metadata[0].name}.${var.hosted_zone_name}"
#       http {
#         path {
#           path_type = "ImplementationSpecific"
#           backend {
#             service {
#               name = kubernetes_service_v1.backend.metadata.0.name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_ingress_v1" "frontend" {
#   wait_for_load_balancer = true

#   metadata {
#     name      = "frontend-${var.env}-${var.project}-port-3000"
#     namespace = kubernetes_namespace.namespace.metadata[0].name
#     annotations = {
#       "alb.ingress.kubernetes.io/load-balancer-name" = var.alb_name
#       "alb.ingress.kubernetes.io/group.name"         = "stage.group"
#       "alb.ingress.kubernetes.io/tags"               = join(",", [for key, value in var.cloud_tech_demo_tags : "${key}=${value}"])
#       "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
#       "alb.ingress.kubernetes.io/subnets"            = "subnet-00507a1542f873ac5,subnet-09c3673129cdb146c"
#       # "alb.ingress.kubernetes.io/security-groups"    = data.aws_security_group.alb.id
#       "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTP\": 80}]"
#       # "alb.ingress.kubernetes.io/certificate-arn"    = each.value.backend_protocol == "HTTPS" ? data.aws_acm_certificate.cert.arn : ""
#       "alb.ingress.kubernetes.io/target-type"        = "ip"
#       "alb.ingress.kubernetes.io/backend-protocol"   = "HTTP"
#       "nginx.ingress.kubernetes.io/rewrite-target"   = "/"
#     }
#   }

#   spec {
#     ingress_class_name = "alb"
#     rule {
#       host = "irc.${kubernetes_namespace.namespace.metadata[0].name}.${var.hosted_zone_name}"
#       http {
#         path {
#           path_type = "ImplementationSpecific"
#           backend {
#             service {
#               name = kubernetes_service_v1.frontend.metadata.0.name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

# data "aws_route53_zone" "cloud_tech_demo" {
#   name         = var.hosted_zone_name
#   private_zone = false
# }

# resource "aws_route53_record" "backend" {
#   allow_overwrite = true
#   name            = "backend.${kubernetes_namespace.namespace.metadata[0].name}.${var.hosted_zone_name}"
#   records         = ["${var.alb_name}.${var.region}.${var.hosted_zone_name}"]
#   ttl             = 60
#   type            = "CNAME"
#   zone_id         = data.aws_route53_zone.cloud_tech_demo.zone_id
# }

# resource "aws_route53_record" "frontend" {
#   allow_overwrite = true
#   name            = "irc.${kubernetes_namespace.namespace.metadata[0].name}.${var.hosted_zone_name}"
#   records         = ["${var.alb_name}.${var.region}.${var.hosted_zone_name}"]
#   ttl             = 60
#   type            = "CNAME"
#   zone_id         = data.aws_route53_zone.cloud_tech_demo.zone_id
# }




