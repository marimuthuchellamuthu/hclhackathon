terraform {
  backend "s3" {
    bucket         = "hcl-hackathon-healthcare"
    key            = "state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "hcl-hackathon-healthcare"
    encrypt        = true
  }
}