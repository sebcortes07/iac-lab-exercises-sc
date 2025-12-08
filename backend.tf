terraform {
  backend "s3" {
    bucket       = "iac-lab-sc-tfstate"
    key          = "eu-central-1/iac-lab-sc/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}