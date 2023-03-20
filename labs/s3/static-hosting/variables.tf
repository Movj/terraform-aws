variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "us-east-1"
}

variable "root_domain" {
    default = "site-main-domain"
}

variable "site_bucket_subdomain" {
    default = "site-subdomain"
}