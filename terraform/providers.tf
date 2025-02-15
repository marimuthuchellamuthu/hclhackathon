# provider.tf
provider "aws" {
  region = "us-east-1"
  access_key = "hcl-hackathon-access-key"
  secret_key = "AKIAX3NVJFI7CSHQPSFG"
}

provider "terraform" {
  version = "~> 1.0"
}