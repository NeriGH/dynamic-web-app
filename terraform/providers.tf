terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
  }
  backend "s3" {
    bucket         = "mybucketvdw1"
    key            = "backend/dynamic-website.tfstate"
    dynamodb_table = "terraform-state-lock"
    region         = "us-east-1"
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}
