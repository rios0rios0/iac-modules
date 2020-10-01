module "webapp" {
  source = "../../modules/azm_app_service"

  region             = var.region
  stack              = var.stack
  environment        = var.environment
  github_branch      = var.github_branch
  github_repository  = var.github_repository
  github_token       = var.github_token
  tags               = var.tags
}
