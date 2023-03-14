// we'll working with a remote state "backed" by a AWS S3 bucket

// first, we need to have creted a bucket, where the state template will live
// then, we must configure as follows
terraform {
  backend "s3" {
    bucket = "bucket-name"
    key = "some-terraform-file.tf.state"
    region = "us-east-1"
    access_key = "value"
    secret_key = "value"
    // config for lock file, must have ddb table created, 
    // we can use a table for multiple lock files
    dynamodb_table = "s3-dynamo-lock"
  }
}

// donot forbide s3 additional permissions

// we can define this in a different file, apart from the module definition