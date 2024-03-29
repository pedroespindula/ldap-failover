data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "terraform_remote_state" "repository" {
  backend = "s3"

  config = {
    region         = "us-east-1"
    bucket         = "lsd-terraform-remote-state"
    key            = "us-east-1/app/repository/terraform.tfstate"
    dynamodb_table = "terraform-lock"
  }
}


data "terraform_remote_state" "backup-bucket" {
  backend = "s3"

  config = {
    region         = "us-east-1"
    bucket         = "lsd-terraform-remote-state"
    key            = "us-east-1/app/backup-bucket/terraform.tfstate"
    dynamodb_table = "terraform-lock"
  }
}

