provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

module "s3" {
  source = "./modules/s3"
  bucket_name_base = var.bucket_name
}

module "cloudfront" {
  source = "./modules/cloudfront"
  s3_origin_id = module.s3.bucket_id
  s3_origin_regional_domain_name = module.s3.regional_domain_name
}