variable "cloud_tech_demo_tags" {
  description = "Default cloud-tech-demo tags"
  default = {
    Application = "cloud-tech-demo"
    Owner       = "krasko"
    Environment = "test"
  }
}

variable "shared_credentials_file" {
  description = "The shared credential file for AWS"
  default     = "~/.aws/credentials"
}

variable "aws_worker_profile" {
  description = "The AWS default worker profile"
  default     = "cloud-tech"
}

variable "region" {
  description = "The AWS regions used for our environment"
  default     = "us-east-1"
}

variable "ecr_rep" {
  description = "Name of ECR"
  default     = "cloud-tech-demo"
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  default     = "cloud-tech-demo"
}

variable "project" {
  description = "Name of project"
  default     = "irc"
}

variable "hosted_zone_name" {
  description = "Name of hosted zone on Route 53"
  default     = "cloud-tech-demo.pp.ua"
}

variable "alb_name" {
  description = "Name of ALB"
  default     = "cloud-tech-demo"
}

variable "vpc_name" {
  description = "Name of VPC"
  default     = "cloud-tech-demo-vpc"
}
