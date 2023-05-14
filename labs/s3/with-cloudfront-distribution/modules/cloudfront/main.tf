# Create Cloudfront distribution

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.s3_origin_regional_domain_name
    origin_id   = var.s3_origin_id
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "cf-for-s3-origin"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 10
    max_ttl                = 20
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}