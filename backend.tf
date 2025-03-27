terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-1234567"
    key            = "envterraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    }
}
