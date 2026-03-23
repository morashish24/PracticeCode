terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.4"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket-am12351"   # change this (must be unique & already created)
    key            = "eksProject/terraform.tfstate"
    region         = "us-east-1"
    profile        = "default"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}