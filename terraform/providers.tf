provider "aws" {
  region                   = var.region
  # shared_credentials_files = [ var.shared_credentials_file ]
  # profile                  = var.aws_worker_profile
}

# data "aws_eks_cluster" "cloud_tech_demo" {
#   name = var.cluster_name
# }

# data "aws_eks_cluster_auth" "cloud_tech_demo" {
#   name = var.cluster_name
# }

provider "kubernetes" {
  host                   = terraform.workspace == "default" ? module.eks[0].eks_endpoint : module.app[0].eks_endpoint
  cluster_ca_certificate = terraform.workspace == "default" ? base64decode(module.eks[0].eks_certificate_authority) : base64decode(module.app[0].eks_certificate_authority)
  token                  = terraform.workspace == "default" ? module.eks[0].eks_auth_token : module.app[0].eks_auth_token
}

provider "kubectl" {
  host                   = terraform.workspace == "default" ? module.eks[0].eks_endpoint : module.app[0].eks_endpoint
  cluster_ca_certificate = terraform.workspace == "default" ? base64decode(module.eks[0].eks_certificate_authority) : base64decode(module.app[0].eks_certificate_authority)
  token                  = terraform.workspace == "default" ? module.eks[0].eks_auth_token : module.app[0].eks_auth_token
  load_config_file       = false
}

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cloud_tech_demo.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cloud_tech_demo.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.cloud_tech_demo.token
# }

# provider "kubectl" {
#   host                   = data.aws_eks_cluster.cloud_tech_demo.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cloud_tech_demo.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.cloud_tech_demo.token
#   load_config_file       = false
# }

# Configure terraform to use tfstate file from S3 bucket.
terraform {
  required_version = "= 1.1.8"

  backend "s3" {
    # profile        = "cloud-tech"
    region         = "us-east-1"
    key            = "cloud-tech/terraform.tfstate"
    bucket         = "terraform-state-lock-cloud-demo"
    dynamodb_table = "terraform-state-lock-cloud-demo-dynamo"
    encrypt        = true
    kms_key_id     = ""
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}