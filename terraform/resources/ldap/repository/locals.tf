locals {
  context = {
    default = {
      name = "lsd-ldap"
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
