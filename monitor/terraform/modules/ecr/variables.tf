variable "name" {
  description = "Name of the service that will be deployed"
  type        = string
}

variable "aws_tags" {
  description = "AWS tags that will be shared bettween the deployed resources"
  type        = map(string)
}

