resource "random_string" "bucket_name_random" {
  length = 6
  special = false
  upper = false
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name_base}-${random_string.bucket_name_random.result}"
  force_destroy = true
}