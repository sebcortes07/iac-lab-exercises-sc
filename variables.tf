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

variable "subnet1_cidr" {
  type        = string
  description = "CIDR block for the first subnet"
}

variable "subnet2_cidr" {
  type        = string
  description = "CIDR block for the second subnet"
}

variable "subnet3_cidr" {
  type        = string
  description = "CIDR block for the third subnet"
}

variable "subnet4_cidr" {
  type        = string
  description = "CIDR block for the fourth subnet"
}

variable "subnet5_cidr" {
  type        = string
  description = "CIDR block for the fifth subnet"
}

variable "subnet6_cidr" {
  type        = string
  description = "CIDR block for the sixth subnet"
}