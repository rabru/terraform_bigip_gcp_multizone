
variable "name" {
  type        = string
  description = "Name of the application"
}

variable "prefix" {
  type        = string
  description = "Prefix could be the name of the environment."
}

variable "region" {
  type        = string
  description = "Region of the environment"
}

variable "instances" {
  type        = list(string)
  description = "List of the BIG-IP instances to be loadbalanced."
}


