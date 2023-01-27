locals {
  context = {
    default = {
      name           = "application"
      vpc            = data.aws_vpc.default
      subnets        = data.aws_subnet_ids.default
      repository_url = data.terraform_remote_state.repository.outputs.repository_url
      tags = {
        Environment = "failover"
      }
    }
  }
}
