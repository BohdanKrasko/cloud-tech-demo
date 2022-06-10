variable "public_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "cloud_tech_demo_tags" {
  description = "Default C tags"
}

variable "ecr_rep" {
  description = ""
}

variable "cluster_name" {
  description = ""
}

variable "aws_worker_profile" {
  description = "The AWS default worker profile"
}

variable "region" {
  description = "The AWS regions used for our environment"
}

variable "logs_namespace" {
  default     = "aws-observability"
  description = "Name of the namespace for CloudWatch Logs"
}

# variable "lucas_testenv_auth" {
#   description = ""
# }

variable "hosted_zone_name" {

}

variable "alb_name" {

}

variable "kms_key_arn" {
  
}

variable "cloud_tech_demo_hosted_zone_id" {
  
}

variable "vpc" {
  
}