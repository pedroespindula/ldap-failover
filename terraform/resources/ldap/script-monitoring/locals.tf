locals {
  context = {
    default = {
      name = "ldap-script-monitoring"
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
