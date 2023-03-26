#  terraform output -json | jq '.["morchella_access_key"]["value"]' | sed -e s/\"//g
output "morchella_access_key" {
  value = module.global.morchella_access_key
}

#  terraform output -json | jq '.["morchella_secret_key"]["value"]' | sed -e s/\"//g
output "morchella_secret_key" {
  value     = module.global.morchella_secret_key
  sensitive = true
}
