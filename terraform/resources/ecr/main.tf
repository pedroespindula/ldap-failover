module "ecr" {
  source   = "../../modules/ecr"
  for_each = local.context[terraform.workspace].repositories

  name = each.key

  aws_tags = each.value.tags
}
