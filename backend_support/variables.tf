variable "prefix" {
  type        = string
  description = "Prefix to be used for naming AWS resources"
  default     = "sc-iac-lab"
}

variable "region" {
  type        = string
  description = "AWS region to deploy the resources"
  default     = "eu-central-1"
}