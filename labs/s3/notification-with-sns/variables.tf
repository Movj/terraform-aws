variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "us-east-1"
}
variable "bucket_name" {
    description = "S3 bucket name"
}
variable "sns_endpoint" {
  description = "SNS topic subscription endpoint, an Email in this case."
}
variable "sns_topic_name" {
  description = "Name for the SNS Topic"
}