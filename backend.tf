terraform {
  backend "s3" {
    bucket       = "iac-lab-jc-tfstate"
    key          = "eu-central-1/iac-lab-jc/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}