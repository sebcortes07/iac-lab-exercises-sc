# S3 bucket
resource "aws_s3_bucket" "terraform_state" {
  # The actual name of the S3 bucket, which will be "sc-tfstate"
  bucket = format("%s-tfstate", var.prefix)
  # Setting force_destroy to true allows the bucket to be destroyed
  force_destroy = true
  # Adding tags to the S3 bucket for identification
  tags = {
    Name = format("%s-tfstate", var.prefix)
  }

  # Prevent the S3 bucket from being destroyed by any command
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Ensure that the S3 bucket is using encryption algorithm AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_default_config" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Ensure that all public access is blocked
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}