module "iam-serviceaccount-github" {
  source = "../../modules/iam-serviceaccount"

  name = local.context[terraform.workspace].name
}
