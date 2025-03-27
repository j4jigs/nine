variable "region" {
  default = "us-east-1"
}

variable "s3_bucket_name" {
  default = "github-cicd-demo-bucket-123456"
}

variable "ami" {
  default = "ami-071226ecf16aa7d96" # Amazon Linux 2 (us-east-1)
}

variable "instance_type" {
  default = "t2.micro"
}
