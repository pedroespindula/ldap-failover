variable "name" {
  description = "Name of the service account user"
  type        = string
}

variable "policy_arn" {
  description = "Policy the role will assume"
  type        = string
}
