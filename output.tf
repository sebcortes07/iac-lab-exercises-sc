output "vpc_id" {
  description = "The ID of the VPC created by this configuration"
  value       = aws_vpc.iac_lab_vpc.id
}