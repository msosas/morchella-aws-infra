#  terraform output -json | jq '.["morchella_access_key"]["value"]' | sed -e s/\"//g
output "morchella_access_key" {
  value = aws_iam_access_key.morchella.id
}

#  terraform output -json | jq '.["morchella_secret_key"]["value"]' | sed -e s/\"//g
output "morchella_secret_key" {
  value     = aws_iam_access_key.morchella.secret
  sensitive = true
}

output "morchella_s3_bucket_id" {
  value = aws_s3_bucket.morchella_nodes.id
}

output "morchella_run_command_role_id" {
  value = aws_iam_role.run_command_role.id
}
