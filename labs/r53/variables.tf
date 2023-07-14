variable "access_key" {

}

variable "secret_key" {

}

variable "region" {
  default = "us-east-2"
}

variable "domain_name" {
  default = "gaby-isra.com"
}

variable "ttl" {
  description = "time to live configuration"
  default     = 60
}