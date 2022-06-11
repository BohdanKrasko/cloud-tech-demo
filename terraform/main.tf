# locals {
#   subnet_ids         = join(",", [ for s in data.aws_subnet.testenv : s.id ]) 
# }

# data "aws_vpc" "cloud_tech_demo" {
#   tags = {
#     Name = var.testenv_vpc["name"]
#   }
# }

# data "aws_subnets" "cloud_tech_demo" {
#   filter {
#     name   = "vpc-id"
#     values = [ data.aws_vpc.cloud_tech_demo.id ]
#   }
# }

# data "aws_subnet" "cloud_tech_demo" {
#   for_each = toset(data.aws_subnets.cloud_tech_demo.ids)
#   id       = each.value
# }

module "eks" {
  count = terraform.workspace == "default" ? 1 : 0
  source       = "./modules/eks"
  cloud_tech_demo_tags = var.cloud_tech_demo_tags
  ecr_rep = var.ecr_rep
  aws_worker_profile = var.aws_worker_profile
  region = var.region
  cluster_name =  var.cluster_name
  # lucas_testenv_auth = data.aws_eks_cluster_auth.cloud_tech_demo
  hosted_zone_name = var.hosted_zone_name
  alb_name = var.alb_name
  kms_key_arn = module.components[0].kms_key_arn
  cloud_tech_demo_hosted_zone_id = module.components[0].cloud_tech_demo_hosted_zone_id
  vpc = module.components[0].vpc
}

module "app" {
  count = terraform.workspace == "default" ? 0 : 1
  source       = "./modules/app"
  project = var.project
  cloud_tech_demo_tags = var.cloud_tech_demo_tags
  region = var.region
  hosted_zone_name = var.hosted_zone_name
  alb_name = var.alb_name
  cluster_name = var.cluster_name
  ecr_rep = var.ecr_rep
}

module "state_locking" {
  count = terraform.workspace == "default" ? 1 : 0
  source       = "./modules/state-locking"
}

module "components" {
  count = terraform.workspace == "default" ? 1 : 0
  source       = "./modules/components"
  region = var.region
  hosted_zone_name = var.hosted_zone_name
  alb_name = var.alb_name
  cloud_tech_demo_tags = var.cloud_tech_demo_tags
  ecr_rep = var.ecr_rep
}