resource "aws_s3_bucket" "myS3bucket" {
  bucket = var.bucketname
}

## bucket ownership
resource "aws_s3_bucket_ownership_controls" "bucketOwn" {
  bucket = aws_s3_bucket.myS3bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

## bucket public
resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.myS3bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucketOwn,
    aws_s3_bucket_public_access_block.public,
  ]

  bucket = aws_s3_bucket.myS3bucket.id
  acl    = "public-read"
}