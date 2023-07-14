
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# sync of the current hosted zone
resource "aws_route53_zone" "default_hosted_zone" {
  name = var.domain_name
}

# certificate for our domains
resource "aws_acm_certificate" "certificate_request" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.{var.domain_name}"]
  validation_method         = "DNS"

  tags = {
    Name : var.domain_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

# DNS validation required - automated way to verify domain,
# this is a dynamic code:  https://github.com/hashicorp/terraform-provider-aws/issues/10098#issuecomment-663562342
resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_aws_acm_certificate.certificate_request.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_name
      type   = dvo.resource_record_type
    }
  }

  zone_id         = aws_route53_zone.default_hosted_zone.zone_id
  ttl             = var.ttl
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  allow_overwrite = true
}

# terraform plan will add a cloudfront distribution to 
# make sure the certificate is working

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate_request.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}

/*
If you see an error like: One or more domain names have failed validation due to a certificate authority authentication (caa) error
you will need to create a Certified Authority Authentication record,  https://support.dnsimple.com/articles/caa-record/ 

To fix it, need to create a CAA record in the existing hosted zone to AUTHORIZE the AWS Cerificate Manager to issue a
certificate for our domain.

issue means that amazon.com can issue a certificate 
issuewild means that amazon.com can issue a wildcard certificate 
*/

resource "aws_route53_record" "caa_record" {
  zone_id = aws_route53_zone.default_hosted_zone.zone_id
  name    = var.domain_name
  type    = "CAA"
  records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\""
  ]
  ttl = var.ttl
}