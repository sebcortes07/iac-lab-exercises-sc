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