provider "aws" {
  region = var.region
  profile = "devops_course"
}

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

# Configure terraform to use tfstate file from S3 bucket.
terraform {
  # required_version = "= 1.1.9"

  # backend "s3" {
  #   region         = "us-east-1"
  #   key            = "cloud-tech/terraform.tfstate"
  #   bucket         = "terraform-state-lock-cloud-demo"
  #   dynamodb_table = "terraform-state-lock-cloud-demo-dynamo"
  #   encrypt        = true
  #   kms_key_id     = ""
  # }

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
