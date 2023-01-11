resource "aws_s3_bucket" "cwl_to_s3" {
  bucket = "${var.project_name}-cwl-to-s3-${local.aws_account_id}"
}

resource "aws_s3_bucket_public_access_block" "cwl_to_s3" {
  bucket                  = aws_s3_bucket.cwl_to_s3.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "cwl_to_s3" {
  bucket = aws_s3_bucket.cwl_to_s3.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "cwl_to_s3" {
  bucket = aws_s3_bucket.cwl_to_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cwl_to_s3" {
  bucket = aws_s3_bucket.cwl_to_s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
