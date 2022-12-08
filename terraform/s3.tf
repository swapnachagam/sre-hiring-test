# Creates S3 bucket for storing/resizing images
resource "aws_s3_bucket" "aircall_bucket" {
  bucket = "aircall-bucket"
  acl    = "public-read"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Project = "aircall"
  }
}