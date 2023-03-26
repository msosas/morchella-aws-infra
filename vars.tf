variable "default_tags" {
  type = map(any)
  default = {
    "Application" = "Morchella"
    "Stack"       = "Provisioning"
    "Terraform"   = "True"
    "Squad"       = "Infra"
    "Environment" = "Production"
  }
}

variable "aws_account_id" {
  type = string
}
