locals {
  context = {
    default = {
      bucket_name = "lsd-terraform-remote-state"
      table_name  = "lsd-terraform-lock"
    }
  }
}
