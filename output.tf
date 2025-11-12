output "vpc_id" {
  description = "The ID of the VPC created by this configuration"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC created by this configuration"
  value       = module.vpc.vpc_arn
}