variable "prefix" {
  type        = string
  description = "Prefix to many of the resources created which helps as an identifier, could be company name, solution name, etc"
  default     = "iac-lab-sc"
}

variable "region" {
  type        = string
  description = "Region to deploy the solution"
  default     = "eu-central-1"
}

variable "repo_name" {
  type        = string
  description = "Repository based on which the GitHub Actions will run"
  default     = "sebcortes07/iac-lab-exercises-sc"
}