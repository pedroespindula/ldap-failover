terraform {
  required_version = "1.0.0"

  required_providers {
    opsgenie = {
      source  = "hashicorp/aws"
      version = "4.51.0"
    }
  }
}
