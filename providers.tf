provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAQLSEHTXEEFL3WW4Z"
  secret_key = "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"
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

provider "http" {
}

