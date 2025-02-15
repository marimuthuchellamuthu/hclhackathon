# s3
terraform {
  backend "s3" {
    bucket         = "hcl-hackathon-healthcare"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "hcl-hackathon-healthcare"
  }
}