variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "image_tags" {
  type = map(string)
  default = {
    frontend  = "latest"
    insurance = "latest"
    patients  = "latest"
    pricing   = "latest"
  }
}
