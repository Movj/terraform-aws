provider "aws" {
     region     = var.region
     access_key = var.access_key
     secret_key = var.secret_key
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
}

module "iam" {
  source = "./modules/iam"
}

module "ec2" {
  source = "./modules/ec2"
  depends_on = [
    module.iam,
    module.s3
  ]
  ec2_role = module.iam.role
  s3_bucket_id = module.s3.bucket_id
}