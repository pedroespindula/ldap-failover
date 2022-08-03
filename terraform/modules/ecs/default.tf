variable "memory" {
  description = "Amount of memory that will be allocated for the container"
  type        = number
  default     = 1024
}

variable "cpu" {
  description = "Amount of CPU that will be allocated for the container"
  type        = number
  default     = 512
}

variable "port" {
  description = "Port that will be binded on the host to expose the service"
  type        = number
  default     = 80
}
