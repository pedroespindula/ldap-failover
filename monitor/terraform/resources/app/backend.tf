terraform {
  backend "s3" {
    bucket = "lsd-terraform-remote-state"
    key    = "us-east-1/app/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "lsd-terraform-lock"
    encrypt        = true
  }
}

