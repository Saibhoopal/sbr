terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.8.0"
    }
  }

  backend "s3" {
    bucket = "CLIENT_BUCKET_NAME"
    key = "terraform.tfstate"
    dynamodb_table = "CLIENT_DYNAMODB_NAME"
    region = "us-east-1"
  }

}

provider "aws" {
  region = "us-east-1"
}


