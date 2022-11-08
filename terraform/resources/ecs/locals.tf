locals {
  context = {
    default = {
      name           = "lsd-ldap"
      vpc            = data.aws_vpc.default
      subnets        = data.aws_subnet_ids.default
      repository_url = "${data.terraform_remote_state.ecr.outputs.repository_url["lsd-ldap"]}:latest"
      tags = {
        Owner       = "lsd"
        Product     = "ldap"
        Team        = "support"
        Squad       = "support"
        Service     = "ldap"
        Environment = "failover"
      }
    }
  }
}
