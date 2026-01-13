terraform {
  backend "s3" {
    key    = "aws-cloudwatch-subscription/terraform.tfstate"
    bucket = "terraform-state-olcb"
    region = "eu-central-1"
  }
}