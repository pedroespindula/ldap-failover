data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    region         = "us-east-1"
    bucket         = "lsd-terraform-state"
    key            = "us-east-1/lsd/ldap/registry/terraform.tfstate"
    dynamodb_table = "lsd-terraform-lock"
  }
}

data "terraform_remote_state" "backup-bucket" {
  backend = "s3"

  config = {
    region         = "us-east-1"
    bucket         = "lsd-terraform-state"
    key            = "us-east-1/lsd/ldap/backup/terraform.tfstate"
    dynamodb_table = "lsd-terraform-lock"
  }
}

