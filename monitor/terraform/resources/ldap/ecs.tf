module "ecs" {
  source = "../../modules/ecs"

  name = local.context[terraform.workspace].name

  vpc_id     = local.context[terraform.workspace].vpc.id
  subnet_ids = local.context[terraform.workspace].subnets.ids

  ports = [389, 636]

  repository_url = local.context[terraform.workspace].repository_url

  aws_tags = local.context[terraform.workspace].tags
}

