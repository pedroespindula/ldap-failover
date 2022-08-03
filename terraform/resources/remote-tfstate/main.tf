module "remote-tfstate" {
  source = "../../modules/remote-tfstate"

  bucket_name = local.context[terraform.workspace].bucket_name
  table_name  = local.context[terraform.workspace].table_name
}
