locals {
  context = {
    default = {
      name    = "lsd-ldap"
      vpc     = data.aws_vpc.default
      subnets = data.aws_subnet_ids.default
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
