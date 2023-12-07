terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
  }
  backend "s3" {
    bucket         = var.bucket_name
    key            = var.bucket_key
    dynamodb_table = var.dynamodb_table
    region         = var.region
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}