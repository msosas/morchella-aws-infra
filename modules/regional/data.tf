data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "archive_file" "morchella_delete_activation" {
  type        = "zip"
  source_dir  = "${path.module}/${var.lambdas_code_path}/morchella_delete_activation"
  output_path = "${path.module}/${var.lambdas_packages_path}/morchella_delete_activation.zip"
}

data "archive_file" "morchella_register_node" {
  type        = "zip"
  source_dir  = "${path.module}/${var.lambdas_code_path}/morchella_register_node"
  output_path = "${path.module}/${var.lambdas_packages_path}/morchella_register_node.zip"
}

data "archive_file" "morchella_tag_resource" {
  type        = "zip"
  source_dir  = "${path.module}/${var.lambdas_code_path}/morchella_tag_resource"
  output_path = "${path.module}/${var.lambdas_packages_path}/morchella_tag_resource.zip"
}

data "archive_file" "morchella_update_node_status" {
  type        = "zip"
  source_dir  = "${path.module}/${var.lambdas_code_path}/morchella_update_node_status"
  output_path = "${path.module}/${var.lambdas_packages_path}/morchella_update_node_status.zip"
}