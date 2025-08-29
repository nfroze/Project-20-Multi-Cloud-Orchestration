terraform {
  backend "s3" {
    bucket = "p20tfstate"
    key    = "aws/terraform.tfstate"
    region = "us-east-1"
  }
}