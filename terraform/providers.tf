terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  #  access_key = "hcl-hackathon-access-key"
  #  secret_key = "AKIAX3NVJFI7CSHQPSFG"
}