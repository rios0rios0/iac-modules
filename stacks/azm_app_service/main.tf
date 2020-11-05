module "app" {
  source = "../../modules/azm_app_service"

  region                     = var.region
  stack                      = var.stack
  environment                = var.environment
  github_branch              = var.github_branch
  github_repository          = var.github_repository
  github_token               = var.github_token
  enable_storage_account     = var.enable_storage_account
  storage_account_name       = var.storage_account_name
  storage_account_path       = var.storage_account_path
  storage_account_access_key = var.storage_account_access_key
  tags                       = var.tags
}
