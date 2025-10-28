# S3 bucket
resource "aws_s3_bucket" "tfstate_backend" {
  # The actual name of the S3 bucket, which will be "${var.prefix}-tfstate"
  bucket = "${var.prefix}-tfstate"
  # Setting force_destroy to true allows the bucket to be destroyed
  force_destroy = true
  # Adding tags to the S3 bucket for identification
  tags = {
    Name = "${var.prefix}-tfstate"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "tfstate_backend_versioning" {
  bucket = aws_s3_bucket.tfstate_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Ensure that the S3 bucket is using encryption algorithm AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_backend_sse" {
  bucket = aws_s3_bucket.tfstate_backend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Ensure that all public access is blocked
resource "aws_s3_bucket_public_access_block" "tfstate_backend_public_access" {
  bucket                  = aws_s3_bucket.tfstate_backend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}