locals {
  context = {
    default = {
      bucket_name = "lsd-terraform-state"
      table_name  = "lsd-terraform-lock"
    }
  }
}
