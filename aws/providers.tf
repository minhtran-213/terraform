provider "aws" {
  region     = "us-west-1"
  access_key = ""
  secret_key = ""
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
  state = "available"
}

provider "http" {
}

