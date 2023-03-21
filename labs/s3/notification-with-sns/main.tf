provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "s3" {
  source = "./modules/s3"
  bucket_name_base = var.bucket_name
}

module "sns" {
  source = "./modules/sns"
  bucket_arn = module.s3.bucket_arn
  topic_name = var.sns_topic_name
  endpoint = var.sns_endpoint
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.s3.bucket_id
  topic {
    topic_arn = module.sns.topic_arn
    events = [
        "s3:ObjectCreated:*"
    ]
  }
}