variable "name" {
  description = "Name of the service that will be deployed"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC that will be used to deploy the load balancer target group"
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "The vpc_id value must be a valid vpc id, starting with \"vpc-\"."
  }
}

variable "subnet_ids" {
  description = "ID of the VPC that will be used to deploy the load balancer target group"
  type        = list(string)

  validation {
    condition     = alltrue([for id in var.subnet_ids : can(regex("^subnet-", id))])
    error_message = "The subnet_id value must be a valid subnet id for all entries, starting with \"subnet-\"."
  }
}

variable "aws_tags" {
  description = "AWS tags that will be shared bettween the deployed resources"
  type = object({
    Owner       = string
    Product     = string
    Team        = string
    Squad       = string
    Service     = string
    Environment = string
  })
}

