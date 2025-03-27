terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

resource "aws_instance" "my_ec2" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "GitHub-EC2"
  }
}
