variable "public_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "logs_namespace" {
  default     = "aws-observability"
  description = "Name of the namespace for CloudWatch Logs"
}

variable "cloud_tech_demo_tags" {
  description = "Default cloud-tech-demo tags"
}

variable "ecr_rep" {
  description = "Name of ECR"
}

variable "cluster_name" {
  description = "Name of EKS cluster"
}

variable "aws_worker_profile" {
  description = "The AWS default worker profile"
}

variable "region" {
  description = "The AWS regions used for our environment"
}

variable "hosted_zone_name" {
  description = "Name of hosted zone on Route 53"
}

variable "alb_name" {
  description = "Name of ALB"
}

variable "kms_key_arn" {
  description = "AWS KMS Key ARN"
}

variable "vpc" {
  description = "AWS VPC"
}
