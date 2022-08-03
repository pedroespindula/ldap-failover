terraform {
  backend "s3" {
    bucket = "lsd-terraform-state"
    key    = "us-east-1/lsd/iam-users/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "lsd-terraform-lock"
    encrypt        = true
  }
}
