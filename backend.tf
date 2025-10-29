terraform {
  backend "s3" {
    bucket = "sc-iac-lab-tfstate"
    key    = "eu-central-1/sc-iac-lab-tfstate/terraform.tfstate"
    region = "eu-central-1"
    // dynamodb_table = "sc-iac-lab-tfstate-locks"
    encrypt      = true
    use_lockfile = true // Enable S3-native locking
  }
}