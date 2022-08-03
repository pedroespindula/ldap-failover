module "ecr" {
  source = "../../../../modules/ecr"

  name = local.context[terraform.workspace].name

  aws_tags = local.context[terraform.workspace].tags
}
