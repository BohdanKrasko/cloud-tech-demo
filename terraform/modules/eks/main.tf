locals {
  eks_subnets_private_tags = tomap({
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  })
  eks_subnets_public_tags = tomap({
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"           = 1
  })
  kubeconfig = templatefile("components/templates/kubeconfig.tpl", {
    certificate_authority_data = aws_eks_cluster.cloud_tech_demo.certificate_authority[0].data
    endpoint = aws_eks_cluster.cloud_tech_demo.endpoint
    cluster_arn = aws_eks_cluster.cloud_tech_demo.arn
    aws_region = var.region
    cluster_name = aws_eks_cluster.cloud_tech_demo.name
    aws_profile = var.aws_worker_profile
  })
  subnet_ids         = join(",", [ for s in aws_subnet.private.*.id : s ])
}

data "aws_subnets" "cloud_tech_demo" {
  filter {
    name   = "vpc-id"
    values = [ var.vpc.id ]
  }
}

# data "aws_subnets" "private" {
#   filter {
#     name   = "vpc-id"
#     values = [ var.vpc.id ]
#   }

#   tags = {
#     Tier = "Private"
#   }
# }



# Network
data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "gw" {

  vpc_id = var.vpc.id

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "cloud-tech-demo-igw" }))

}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = var.vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.cloud_tech_demo_tags, local.eks_subnets_public_tags, tomap({ "Name" = format("cloud-tech-demo-public-%d", count.index), "Tier" = "Public" }))
}

resource "aws_subnet" "private" {
  count = length(var.public_subnets)

  vpc_id                  = var.vpc.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.cloud_tech_demo_tags, local.eks_subnets_private_tags, tomap({ "Name" = format("cloud-tech-demo-private-%d", count.index), "Tier" = "Private" }))
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  # depends_on = [aws_internet_gateway.id]
  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "cloud-tech-demo-nat-eip" }))
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public.*.id, 0)

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "cloud-tech-demo-nat" }))
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = var.vpc.id

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "cloud-tech-demo-private-route-table" }))
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = var.vpc.id

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "cloud-tech-demo-public-route-table" }))
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}




#EKS
data "aws_eks_cluster" "cloud_tech_demo" {
  name = aws_eks_cluster.cloud_tech_demo.name
}

data "aws_eks_cluster_auth" "cloud_tech_demo" {
  name = aws_eks_cluster.cloud_tech_demo.name
}

resource "aws_eks_cluster" "cloud_tech_demo" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cloud_tech_demo.arn
  version = "1.22"

  vpc_config {
    subnet_ids              = data.aws_subnets.cloud_tech_demo.ids
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids = [ aws_security_group.eks_api_private_access.id ]
  }

  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = [ "secrets" ]
  }

  # enabled_cluster_log_types = [ "api" ]
  
  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = var.cluster_name }))

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cloud_tech_demo_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cloud_tech_demo_AmazonEKSVPCResourceController,
  ]
}

# Security group
resource "aws_security_group" "eks_api_private_access" {
  name   = "eks-api-private-access"
  vpc_id = var.vpc.id

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "eks-api-private-access" }))
}

resource "aws_security_group_rule" "inbound_rule_allow_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks       = [ var.vpc.cidr_block ]
  security_group_id        = aws_security_group.eks_api_private_access.id
}

resource "aws_security_group_rule" "outbound_rule_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.eks_api_private_access.id
}

# IAM ROLE FOR EKS CLUSTER
data "aws_iam_policy_document" "cloud_tech_demo_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloud_tech_demo" {
  name               = "eks-cluster-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.cloud_tech_demo_role_policy.json

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "eks-cluster-${var.cluster_name}" }))
}

resource "aws_iam_role_policy_attachment" "cloud_tech_demo_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.cloud_tech_demo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cloud_tech_demo_AmazonEKSVPCResourceController" {
  role       = aws_iam_role.cloud_tech_demo.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

data "aws_iam_policy_document" "cloud_watch" {
  statement {
    sid = "CloudWatchPermission"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

#IAM ROLE FOR EKS FARGATE PROFILE
data "aws_iam_policy_document" "cloud_tech_demo_pod_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecr" {
  statement {
    sid = "ECR"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "cloud_tech_demo_pod" {
  name               = "eks-fargate-profile"
  assume_role_policy = data.aws_iam_policy_document.cloud_tech_demo_pod_role_policy.json

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "eks-fargate-profile" }))
}

resource "aws_iam_policy" "cloud_watch" {
  name        = "CloudWatchIAMPolicy"
  path        = "/"
  description = "CloudWatch IAM Policy"
  policy      = data.aws_iam_policy_document.cloud_watch.json

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "CloudWatchIAMPolicy" }))
}

resource "aws_iam_policy" "ecr" {
  name        = "ECRIAMPolicy"
  path        = "/"
  description = "ECR IAM Policy"
  policy      = data.aws_iam_policy_document.ecr.json

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "ECRIAMPolicy" }))
}

resource "aws_iam_role_policy_attachment" "cloud_watch" {
  role       = aws_iam_role.cloud_tech_demo_pod.name
  policy_arn = aws_iam_policy.cloud_watch.arn
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.cloud_tech_demo_pod.name
  policy_arn = aws_iam_policy.ecr.arn
}

resource "aws_iam_role_policy_attachment" "cloud_tech_demo_pod_AmazonEKSFargatePodExecutionRolePolicy" {
  role       = aws_iam_role.cloud_tech_demo_pod.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}


# DELETE DEFAULT COREDNS DEPLOYMENT
resource "local_file" "kubeconfig" {
  content              = local.kubeconfig
  filename             = "./kubeconfig-${aws_eks_cluster.cloud_tech_demo.name}"
  file_permission      = "0600"
  directory_permission = "0755"

  depends_on = [
    aws_eks_cluster.cloud_tech_demo
  ]
}

resource "null_resource" "coredns" {
  triggers = {
    eks_cluster = aws_eks_cluster.cloud_tech_demo.name
  }

  provisioner "local-exec" {
    command = "KUBECONFIG=${local_file.kubeconfig.filename} kubectl delete deployment coredns -n kube-system"
  }
}

# ADD TAGS FOR PRIMARY EKS SG
resource "aws_ec2_tag" "cluster_primary_security_group" {
  for_each = var.cloud_tech_demo_tags

  resource_id = aws_eks_cluster.cloud_tech_demo.vpc_config[0].cluster_security_group_id
  key         = each.key
  value       = each.value

  depends_on = [
    aws_eks_cluster.cloud_tech_demo
  ]
}

# FARGATE PROFILES
resource "aws_eks_fargate_profile" "cert_manager" {
  cluster_name           = aws_eks_cluster.cloud_tech_demo.name
  fargate_profile_name   = "cert-manager"
  pod_execution_role_arn = aws_iam_role.cloud_tech_demo_pod.arn
  subnet_ids             = aws_subnet.private.*.id

  selector {
    namespace = "cert-manager"
  }

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "fargate-profile-cert-manager" }))
}

resource "aws_eks_fargate_profile" "kube_system" {
  cluster_name           = aws_eks_cluster.cloud_tech_demo.name
  fargate_profile_name   = "kube-system"
  pod_execution_role_arn = aws_iam_role.cloud_tech_demo_pod.arn
  subnet_ids             = aws_subnet.private.*.id

  selector {
    namespace = "kube-system"
    # labels = {
    #   "k8s-app" = "kube-dns"
    # }
  }

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "fargate-profile-kube-system" }))
}

resource "aws_eks_fargate_profile" "stage" {
  cluster_name           = aws_eks_cluster.cloud_tech_demo.name
  fargate_profile_name   = "stage"
  pod_execution_role_arn = aws_iam_role.cloud_tech_demo_pod.arn
  subnet_ids             = aws_subnet.private.*.id

  selector {
    namespace = "stage"
  }

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "stage" }))
}


resource "aws_eks_fargate_profile" "prod" {
  cluster_name           = aws_eks_cluster.cloud_tech_demo.name
  fargate_profile_name   = "prod"
  pod_execution_role_arn = aws_iam_role.cloud_tech_demo_pod.arn
  subnet_ids             = aws_subnet.private.*.id

  selector {
    namespace = "prod"
  }

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "prod" }))
}

#ADD-ONS
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.cloud_tech_demo.name
  addon_name   = "vpc-cni"

  lifecycle {
    ignore_changes = [
      modified_at
    ]
  }

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "vpc-cni" }))

  depends_on = [
    aws_eks_fargate_profile.kube_system,
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.cloud_tech_demo.name
  addon_name        = "coredns"
  resolve_conflicts = "OVERWRITE"

  lifecycle {
    ignore_changes = [
      modified_at
    ]
  }

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "coredns" }))

  depends_on = [
    aws_eks_fargate_profile.kube_system,
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.cloud_tech_demo.name
  addon_name        = "kube-proxy"
  resolve_conflicts = "OVERWRITE"

  lifecycle {
    ignore_changes = [
      modified_at
    ]
  }

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "kube-proxy" }))

  depends_on = [
    aws_eks_fargate_profile.kube_system,
  ]
}

#IAM ROLE FOR SERVICE ACCOUNT
data "tls_certificate" "cloud_tech_demo" {
  url = aws_eks_cluster.cloud_tech_demo.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "cloud_tech_demo_assume_role_policy" {
  statement {
    actions = [ "sts:AssumeRoleWithWebIdentity" ]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cloud_tech_demo.url, "https://", "")}:sub"
      values   = [ "system:serviceaccount:kube-system:aws-load-balancer-controller" ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cloud_tech_demo.url, "https://", "")}:aud"
      values   = [ "sts.amazonaws.com" ]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cloud_tech_demo.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_openid_connect_provider" "cloud_tech_demo" {
  client_id_list  = [ "sts.amazonaws.com" ]
  thumbprint_list = [ data.tls_certificate.cloud_tech_demo.certificates[0].sha1_fingerprint ]
  url             = aws_eks_cluster.cloud_tech_demo.identity[0].oidc[0].issuer

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "cloud-tech-demo" }))
}

resource "aws_iam_role" "aws_load_balancer_controller_role" {
  assume_role_policy = data.aws_iam_policy_document.cloud_tech_demo_assume_role_policy.json
  name               = "aws-load-balancer-controller"

  tags = merge(var.cloud_tech_demo_tags,
    tomap({ "alpha.eksctl.io/cluster-name" = aws_eks_cluster.cloud_tech_demo.name }),
    tomap({ "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = aws_eks_cluster.cloud_tech_demo.name }),
    tomap({ "alpha.eksctl.io/iamserviceaccount-name" = "kube-system/aws-load-balancer-controller" }),
    tomap({ "alpha.eksctl.io/eksctl-version" = "0.79.0" }),
    tomap({ "Name" = "aws-load-balancer-controller" }))
}

resource "aws_iam_policy" "ingress_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "ALB Ingress Controller IAM Policy"
  policy      = file("components/policy/iam-policy.json")

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "AWSLoadBalancerControllerIAMPolicy" }))
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_role_AWSLoadBalancerControllerIAMPolicy" {
  role       = aws_iam_role.aws_load_balancer_controller_role.name
  policy_arn = aws_iam_policy.ingress_policy.arn
}


#SERVICE ACCOUNT
resource "kubernetes_service_account" "cloud_tech_demo" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller_role.arn
    }
  }

  depends_on = [
    aws_eks_cluster.cloud_tech_demo,
    aws_iam_role.aws_load_balancer_controller_role,
  ]
}

#RBAC ROLE
resource "kubernetes_cluster_role" "rbac_role" {
  metadata {
    name = "aws-load-balancer-controller"
    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs      = ["create", "get", "list", "update", "watch", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }

  depends_on = [
    aws_eks_cluster.cloud_tech_demo
  ]
}

resource "kubernetes_cluster_role_binding" "rbac_role" {
  metadata {
    name = "aws-load-balancer-controller"
    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "aws-load-balancer-controller"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
  }

  depends_on = [
    aws_eks_cluster.cloud_tech_demo,
    kubernetes_cluster_role.rbac_role
  ]
}

#CLOUDWATCH SETUP
resource "kubernetes_namespace" "aws_observability" {
  metadata {
    labels = {
      aws-observability = "enabled"
    }
    name = var.logs_namespace
  }

  depends_on = [
    aws_eks_cluster.cloud_tech_demo
  ]
}

resource "kubernetes_config_map" "aws_observability" {
  metadata {
    name      = "aws-logging"
    namespace = var.logs_namespace
  }

  data = {
    "filters.conf" = <<-EOT
      [FILTER]
        Name parser
        Match *
        Key_name log
        Parser crio
    EOT
    "output.conf"  = <<-EOT
      [OUTPUT]
        Name cloudwatch_logs
        Match   *
        region us-east-1
        log_group_name eks-pods-logs
        log_stream_prefix from-eks-pods-
        auto_create_group true
        log_key log
    EOT
    "parsers.conf" = <<-EOT
      [PARSER]
        Name crio
        Format Regex
        Regex ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>P|F) (?<log>.*)$
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L%z
    EOT
  }

  depends_on = [
    aws_eks_cluster.cloud_tech_demo,
    kubernetes_namespace.aws_observability
  ]
}

data "kubectl_path_documents" "cert_manager" {
    pattern = "components/manifest/cert-manager.yaml"
}

resource "kubectl_manifest" "cert_manager" {
  for_each = data.kubectl_path_documents.cert_manager.manifests
  yaml_body = each.value

  depends_on = [
    aws_eks_fargate_profile.cert_manager,
    kubernetes_config_map.aws_observability
  ]
}

data "kubectl_path_documents" "ingress_alb_controller" {
    pattern = "components/manifest/v2_4_1_full.yaml"
}

resource "kubectl_manifest" "ingress_alb_controller" {
  for_each = data.kubectl_path_documents.ingress_alb_controller.manifests
  yaml_body = each.value

  depends_on = [
    kubectl_manifest.cert_manager,
    aws_eks_fargate_profile.kube_system
  ]
}

resource "kubernetes_namespace" "dummy" {
  metadata {
    name = "dummy"
  }
}

resource "kubernetes_service_v1" "dummy" {
  metadata {
    name = "dummy-service"
    namespace = kubernetes_namespace.dummy.metadata[0].name
  }
  spec {
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "dummy" {
  wait_for_load_balancer = true

  metadata {
    name      = "dummy"
    namespace = kubernetes_namespace.dummy.metadata[0].name
    annotations = {
      "alb.ingress.kubernetes.io/load-balancer-name" = var.alb_name
      "alb.ingress.kubernetes.io/group.name"         = "stage.group"
      "alb.ingress.kubernetes.io/tags"               = join(",", [for key, value in var.cloud_tech_demo_tags : "${key}=${value}"])
      "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
      "alb.ingress.kubernetes.io/subnets"            = local.subnet_ids
      # "alb.ingress.kubernetes.io/security-groups"    = aws_security_group.alb.id
      "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTP\": 80}]"
      # "alb.ingress.kubernetes.io/certificate-arn"    = ""
      "alb.ingress.kubernetes.io/target-type"        = "ip"
      "alb.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/rewrite-target"   = "/"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "dummy.${var.hosted_zone_name}"
      http {
        path {
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service_v1.dummy.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubectl_manifest.ingress_alb_controller
  ]
}

data "aws_elb_hosted_zone_id" "main" {}

resource "aws_route53_record" "cloud_tech_demo_ingress" {
  zone_id = var.cloud_tech_demo_hosted_zone_id
  name    = "${var.alb_name}.${var.region}.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = kubernetes_ingress_v1.dummy.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = true
  }
}

