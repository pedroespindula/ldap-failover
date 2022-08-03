module "ecs" {
  source = "../../modules/ecs"

  name = local.context[terraform.workspace].name

  vpc_id     = local.context[terraform.workspace].vpc.id
  subnet_ids = local.context[terraform.workspace].subnets.ids

  port = 389

  aws_tags = local.context[terraform.workspace].tags
}
