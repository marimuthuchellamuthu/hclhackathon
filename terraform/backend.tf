# s3
terraform {
  backend "s3" {
    bucket         = "hcl-hackathon-healthcare"
    key            = "state/${terraform.workspace}.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "hcl-hackathon-healthcare"
  }
}