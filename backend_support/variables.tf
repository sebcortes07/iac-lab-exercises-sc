variable "prefix" {
  type        = string
  description = "Prefix to be used for naming AWS resources"
  # Default value
  default = "sc-iac-lab"
}

variable "region" {
  type        = string
  description = "AWS region to deploy the resources"
  # Default value
  default = "eu-central-1"
}