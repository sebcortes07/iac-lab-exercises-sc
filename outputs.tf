output "vpc_id" {
  description = "The ID of the VPC created by this configuration"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC created by this configuration"
  value       = module.vpc.vpc_arn
}

output "ecr_url" {
  description = "The URL of the ECR created by the ECS module"
  value       = module.ecs.ecr_url
}

output "website_url" {
  description = "The website URL."
  value       = format("http://%s/users", aws_lb.lb.dns_name)
}

output "db_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.database.address
}