variable "environment" {
  type = string
}

variable "repository_names" {
  type    = list(string)
  default = ["healthcare-frontend", "healthcare-insurance", "healthcare-patients", "healthcare-pricing"]
}
