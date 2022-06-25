variable "project" {
  description = "Name of project"
}

variable "cloud_tech_demo_tags" {
  description = "Default cloud-tech-demo tags"
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

variable "cluster_name" {
  description = "Name of EKS cluster"
}

variable "ecr_rep" {
  description = "Name of ECR"
}

variable "vpc_name" {
  description = "Name of VPC"
}
