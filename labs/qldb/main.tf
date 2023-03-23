provider "aws" {
    region     = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

resource "aws_qldb_ledger" "ledger" {
  name = "DMV"
  permissions_mode = "ALLOW_ALL"
  deletion_protection = false
}

