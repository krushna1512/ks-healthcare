variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "container_ports" {
  type    = list(number)
  default = [80, 3001, 3002, 3003]
}
