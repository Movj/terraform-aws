resource "random_string" "bucket_name_random" {
  length = 6
  special = false
  upper = false
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name_base}-${random_string.bucket_name_random.result}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:list*",
        "s3:get*",
        "s3:putobject"
        ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_s3_object" "assets_upload" {
  for_each = fileset("${path.module}/assets/", "*")
  key = each.value
  bucket = aws_s3_bucket.bucket.id
  source = "${path.module}/assets/${each.value}"
  etag = filemd5("${path.module}/assets/${each.value}")
  content_type = "image/jpeg"
}