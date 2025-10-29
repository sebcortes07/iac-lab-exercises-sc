output "vpc_id" {
  description = "The ID of the VPC created by this configuration"
  value       = aws_vpc.vpc.id
}