variable "cloud_tech_demo_tags" {
  default = {
    Application    = "cloud-tech-demo"
    Owner = "krasko"
    Environment = "test"
  }
  description = "Default C tags"
}

variable "shared_credentials_file" {
  default     = "~/.aws/credentials"
  description = "The shared credential file for AWS"
}

variable "aws_worker_profile" {
  default     = "cloud-tech"
  description = "The AWS default worker profile"
}

variable "region" {
  default     = "us-east-1"
  description = "The AWS regions used for our environment"
}

variable "ecr_rep" {
  default     = "cloud-tech-demo"
  description = ""
}

variable "cluster_name" {
  default = "cloud-tech-demo"
}

variable "project" {
  description = ""
  default = "irc"
}

variable "hosted_zone_name" {
  default = "cloud-tech-demo.pp.ua"
}

variable "alb_name" {
  default = "cloud-tech-demo"
}

variable "vpc_name" {
  default = "cloud-tech-demo-vpc"
}