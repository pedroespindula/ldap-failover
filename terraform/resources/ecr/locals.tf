locals {
  context = {
    default = {
      repositories = {
        "lsd-ldap" : {
          tags = {
            Owner       = "lsd"
            Product     = "ldap"
            Team        = "support"
            Squad       = "support"
            Service     = "ldap"
            Environment = "failover"
          }
        },
        "lsd-ldap-detect-fail" : {
          tags = {
            Owner       = "lsd"
            Product     = "ldap-detect-fail"
            Team        = "support"
            Squad       = "support"
            Service     = "ldap-detect-fail"
            Environment = "failover"
          }
        }
        "lsd-ldap-backup" : {
          tags = {
            Owner       = "lsd"
            Product     = "ldap-backup"
            Team        = "support"
            Squad       = "support"
            Service     = "ldap-backup"
            Environment = "failover"
          }
        }
      }
    }
  }
}
