data "terraform_remote_state" "repository" {
  backend = "s3"

  config = {
    region         = "us-east-1"
    bucket         = "lsd-terraform-remote-state"
    key            = "us-east-1/lsd/ldap/script-monitoring/repository/terraform.tfstate"
    dynamodb_table = "lsd-terraform-lock"
  }
}
