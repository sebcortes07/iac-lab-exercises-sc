resource "aws_ecr_repository" "api" {
  name = "${var.prefix}-crud-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name = "${var.prefix}-crud-app"
  }
}