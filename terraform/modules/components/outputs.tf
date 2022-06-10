output "kms_key_arn" {
  value =  aws_kms_key.cloud_tech_demo.arn
}

output "cloud_tech_demo_hosted_zone_id" {
  value = aws_route53_zone.cloud_tech.zone_id
}

output "vpc" {
  value = aws_vpc.vpc
}