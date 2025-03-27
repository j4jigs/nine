variable "region" {
  type    = string
  default = "us-east-1"
}

#variable "s3_bucket_name" {
#  type    = string
#  default = "github-cicd-demo-bucket-123456"
#}

variable "ami" {
  type    = string
  default = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
