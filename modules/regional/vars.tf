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


variable "lambdas_packages_path" {
  type    = string
  default = "./lambdas/packages"
}

variable "lambdas_code_path" {
  type    = string
  default = "./lambdas/code"
}

variable "lambda_timeout" {
  type    = number
  default = 15
}

variable "morchella_nodes_s3_name" {
  type = string
}

variable "morchella_run_command_role_id" {
  type = string
}