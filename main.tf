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

##adding object to bucket 
resource "aws_s3_object" "index" {
   key                    = "index.html"
  bucket                 = aws_s3_bucket.myS3bucket.id
  source                 = "index.html"
  acl                    = "public-read"
  content_type           = "text/html"
}

resource "aws_s3_object" "error" {
  key                    = "error.html"
  bucket                 = aws_s3_bucket.myS3bucket.id
  source                 = "error.html"  ## file at current location
  acl                    = "public-read"
  content_type           = "text/html"
}

##s3 static website configuration
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.myS3bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.bucket_acl ]
}
