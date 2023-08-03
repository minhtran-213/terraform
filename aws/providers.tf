provider "aws" {
  region     = "us-west-1"
  access_key = "AKIAQLSEHTXEKDALNNGP"
  secret_key = "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"
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
  state = "available"
}

provider "http" {
}

