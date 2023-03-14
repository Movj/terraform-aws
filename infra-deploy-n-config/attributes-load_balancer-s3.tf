//provider "aws" {
//  region = "us-west-2"
//  access_key = "foo"
//  secret_key = "bar"
//}

resource "aws_eip" "mylb" {
    vpc = true
}

output "eip" {
  value = aws_eip.mylb
}

resource "aws_s3_bucket" "mys3" {
  bucket = "my-bucket-name"
}

output "mys3bucket" {
  value = aws_s3_bucket.mys3.bucket_domain_name // being specific with the output
}