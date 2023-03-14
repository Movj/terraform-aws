

// sometimes we will need providers not supported by Hashi
// and we need to call them with 

terraform {
  required_providers {
    digitalocean = {
        source = "digitalocean/digitalocean"
        version = "~> 2.0"
    }
    github = {
        source = "integrations/github"
        version = "4.17.0"
    }
    // defining a provider for specific version
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0" // ">= 2.0, <= 2.5"
    }
  }
}

provider "aws" {
  region = ""
  // all prop here
}

provider "azurerm" {
  // all prop here
}

provider "digitalocean" {
    // check extra settings 
}

provider "github" {
  // config options
  // token = "XASXAXASX"
}