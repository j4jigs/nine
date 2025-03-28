terraform {
  backend "s3" {
    bucket  = "my-terraform-state-bucket-123456789"
    key     = "envterraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
