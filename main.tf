module "global" {
  # IAM + S3
  source = "./modules/global"
}

module "us_east_1" {
  source                        = "./modules/regional"
  morchella_nodes_s3_name       = module.global.morchella_s3_bucket_id
  morchella_run_command_role_id = module.global.morchella_run_command_role_id
  providers = {
    aws = aws.us-east-1
  }
}

# module "us_west_2" {
#   source                        = "./modules/regional"
#   morchella_nodes_s3_name       = module.global.morchella_s3_bucket_id
#   morchella_run_command_role_id = module.global.morchella_run_command_role_id
#   providers = {
#     aws = aws.us-west-2
#   }
# }

# module "us_west_1" {
#   source                        = "./modules/regional"
#   morchella_nodes_s3_name       = module.global.morchella_s3_bucket_id
#   morchella_run_command_role_id = module.global.morchella_run_command_role_id
#   providers = {
#     aws = aws.us-west-1
#   }
# }

# module "ap_southeast_2" {
#   source                        = "./modules/regional"
#   morchella_nodes_s3_name       = module.global.morchella_s3_bucket_id
#   morchella_run_command_role_id = module.global.morchella_run_command_role_id
#   providers = {
#     aws = aws.ap-southeast-2
#   }
# }