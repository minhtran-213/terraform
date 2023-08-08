provider "aws" {
  region     = "us-west-2"
  profile = "default"
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
  state = "available"
}


provider "http" {
}

