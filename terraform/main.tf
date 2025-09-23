module "vpc" {
  source = "./modules/gateway"
  org    = var.org
  env    = var.env
  vpc_id = var.vpc_id
  sha    = var.sha
}