resource "aws_s3_bucket" "blog" {
    bucket = var.bucket_name
    # acl = "private" // it is private by default
}

resource "aws_s3_object" "upload_obj" {
  for_each = fileset("${path.module}/html/", "*")
  key = each.value
  bucket = aws_s3_bucket.blog.id
  source = "${path.module}/html/${each.value}"
  etag = filemd5("${path.module}/html/${each.value}")
  content_type = "text/html"
}