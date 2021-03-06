# Route 53
resource "aws_route53_zone" "cloud_tech" {
  name = var.hosted_zone_name

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = var.hosted_zone_name }))
}

# KMS Key
resource "aws_kms_key" "cloud_tech_demo" {
  description         = "KMS key for Cloud Tech Demo"
  enable_key_rotation = true

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "cloud-tech-demo-kms-key" }))
}

# ECR
resource "aws_ecr_repository" "cloud_tech_demo" {
  name                 = var.ecr_rep
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.cloud_tech_demo.arn
  }

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = "cloud-tech-demo" }))
}


# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.cloud_tech_demo_tags, tomap({ "Name" = var.vpc_name }))
}

# SSM Parameters
resource "aws_ssm_parameter" "db_stage" {
  name        = "/cloud-tech-demo/db/stage"
  description = "Store the current DB image tag"
  type        = "SecureString"
  value       = "cloud-tech-demo-stage-db-b39f5f0-32"
  key_id      = aws_kms_key.cloud_tech_demo.arn

  lifecycle {
    ignore_changes = [
      value,
      version
    ]
  }

  tags = var.cloud_tech_demo_tags
}

resource "aws_ssm_parameter" "db_prod" {
  name        = "/cloud-tech-demo/db/prod"
  description = "Store the current DB image tag"
  type        = "SecureString"
  value       = "cloud-tech-demo-prod-db-b39f5f0-32"
  key_id      = aws_kms_key.cloud_tech_demo.arn

  lifecycle {
    ignore_changes = [
      value,
      version
    ]
  }

  tags = var.cloud_tech_demo_tags
}

resource "aws_ssm_parameter" "backend_stage" {
  name        = "/cloud-tech-demo/backend/stage"
  description = "Store the current Backend image tag"
  type        = "SecureString"
  value       = "cloud-tech-demo-stage-backend-b39f5f0-32"
  key_id      = aws_kms_key.cloud_tech_demo.arn

  lifecycle {
    ignore_changes = [
      value,
      version
    ]
  }

  tags = var.cloud_tech_demo_tags
}

resource "aws_ssm_parameter" "backend_prod" {
  name        = "/cloud-tech-demo/backend/prod"
  description = "Store the current Backend image tag"
  type        = "SecureString"
  value       = "cloud-tech-demo-prod-backend-b39f5f0-32"
  key_id      = aws_kms_key.cloud_tech_demo.arn

  lifecycle {
    ignore_changes = [
      value,
      version
    ]
  }

  tags = var.cloud_tech_demo_tags
}

resource "aws_ssm_parameter" "frontend_stage" {
  name        = "/cloud-tech-demo/frontend/stage"
  description = "Store the current Frontend image tag"
  type        = "SecureString"
  value       = "cloud-tech-demo-prod-frontend-b39f5f0-32"
  key_id      = aws_kms_key.cloud_tech_demo.arn

  lifecycle {
    ignore_changes = [
      value,
      version
    ]
  }

  tags = var.cloud_tech_demo_tags
}

resource "aws_ssm_parameter" "frontend_prod" {
  name        = "/cloud-tech-demo/frontend/prod"
  description = "Store the current Frontend image tag"
  type        = "SecureString"
  value       = "cloud-tech-demo-prod-frontend-b39f5f0-32"
  key_id      = aws_kms_key.cloud_tech_demo.arn

  lifecycle {
    ignore_changes = [
      value,
      version
    ]
  }

  tags = var.cloud_tech_demo_tags
}
