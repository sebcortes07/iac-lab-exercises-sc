variable "prefix" {
  type        = string
  description = "Prefix to be used for naming AWS resources"
}

variable "region" {
  type        = string
  description = "AWS region to deploy the resources"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "number_of_public_subnets" {
  type        = number
  description = "number of public subnets"
  default     = 2
}

variable "number_of_private_subnets" {
  type        = number
  description = "number of private subnets"
  default     = 2
}

variable "number_of_secure_subnets" {
  type        = number
  description = "number of secure subnets"
  default     = 2
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_name" {
  type        = string
  description = "Database name"
}