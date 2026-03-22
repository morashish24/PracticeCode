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
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"              # change if needed (must exist)
    profile        = "default"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Get latest Amazon Linux 2 AMI dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2_instance" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.amazon_linux.id

  tags = {
    Name = "MyEC2Instance"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "my-terraform-state-bucket-am12351"  # MUST be globally unique

  tags = {
    Name = "MyS3Bucket"
  }
}

# Output
output "bucket_name" {
  value = aws_s3_bucket.my_s3_bucket.bucket
}

output "ec2_public_ip" {
  value = aws_instance.my_ec2_instance.public_ip
}