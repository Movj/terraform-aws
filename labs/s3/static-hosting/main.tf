// https://registry.terraform.io/modules/cn-terraform/s3-static-website/aws/latest
// creating a s3 serving as static web site hosting

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_s3_bucket" "site" {
  bucket = "${var.site_bucket_subdomain}.${var.root_domain}"
}

resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "site_bucket_acl" {
  bucket = aws_s3_bucket.site.id
  acl = "public-read"
}

// uploading the files for the static website
resource "aws_s3_object" "upload_obj" {
  for_each = fileset("html/", "*")
  key = each.value
  bucket = aws_s3_bucket.site.id
  source = "html/${each.value}"
  etag = filemd5("html/${each.value}")
  content_type = "text/html"
}

// adding policy to make the bucket public readable
resource "aws_s3_bucket_policy" "read_access_policy" {
  bucket = aws_s3_bucket.site.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.site.id}/*"
            ]
        }
    ]
  }
  POLICY
}