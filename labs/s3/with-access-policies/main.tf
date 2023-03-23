provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

resource "random_string" "random" {
  length = 6
  special = false
  upper = false
}

resource "aws_s3_bucket" "bucket" {
  bucket = "bucket-${random_string.random.result}"
  force_destroy = true
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "my-image.png"
  source = "./assets/Bottom-screen-JPEG.jpg"
  etag = md5("./assets/Bottom-screen-JPEG.jpg")
}

// will allow to download bucket files
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
        "s3:ListBucket",
        "s3:GetObject"
        ],
      "Resource": [
        "${aws_s3_bucket.bucket.arn}",
        "${aws_s3_bucket.bucket.arn}/${aws_s3_object.object.key}"
      ]
    }
  ]
}
EOF
}