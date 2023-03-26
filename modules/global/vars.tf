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

variable "morchella_regional_bucket_name_pattern" {
  type = string
  default = "morchella-nodes"
}

variable "morchella_nodes_s3_name" {
  type    = string
  default = "morchella-nodes"
}