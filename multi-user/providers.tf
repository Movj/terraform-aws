provider "aws" {
  region = "us-east-2"
  alias = "ohio"
  profile = "ohio-account"
}

provider "aws" {
  region = "us-east-1"
  alias = "virginia"
  profile = "virginia-account"
}