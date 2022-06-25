module "state_locking" {
  count  = terraform.workspace == "default" ? 1 : 0
  source = "./modules/state-locking"
}

module "components" {
  count                = terraform.workspace == "default" ? 1 : 0
  source               = "./modules/components"
  hosted_zone_name     = var.hosted_zone_name
  alb_name             = var.alb_name
  cloud_tech_demo_tags = var.cloud_tech_demo_tags
  ecr_rep              = var.ecr_rep
  vpc_name             = var.vpc_name
}

module "eks" {
  count                          = terraform.workspace == "default" ? 1 : 0
  source                         = "./modules/eks"
  cloud_tech_demo_tags           = var.cloud_tech_demo_tags
  ecr_rep                        = var.ecr_rep
  aws_worker_profile             = var.aws_worker_profile
  region                         = var.region
  cluster_name                   = var.cluster_name
  hosted_zone_name               = var.hosted_zone_name
  alb_name                       = var.alb_name
  kms_key_arn                    = module.components[0].kms_key_arn
  vpc                            = module.components[0].vpc
  cloud_tech_demo_hosted_zone_id = module.components[0].cloud_tech_demo_hosted_zone_id
}

module "app" {
  count                = terraform.workspace == "default" ? 0 : 1
  source               = "./modules/app"
  project              = var.project
  cloud_tech_demo_tags = var.cloud_tech_demo_tags
  region               = var.region
  hosted_zone_name     = var.hosted_zone_name
  alb_name             = var.alb_name
  cluster_name         = var.cluster_name
  ecr_rep              = var.ecr_rep
  vpc_name             = var.vpc_name
}
