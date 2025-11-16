variable "alb_target_group_arn" {
  type        = string
  description = "ARN of the ALB target group to attach to the ECS service"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group id of the ALB"
}

variable "prefix" {
  type        = string
  description = "Prefix to be used for naming AWS resources"
}

variable "region" {
  type        = string
  description = "AWS region to deploy the resources"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ECS tasks"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_address" {
  type        = string
  description = "Database endpoint address"
}

variable "db_secret_arn" {
  type        = string
  description = "ARN of the Secrets Manager secret for the database password"
}

variable "db_secret_key_id" {
  type        = string
  description = "KMS Key ID for the Secrets Manager secret"
}