module "gateway" {
  source        = "./modules/gateway"
  org           = var.org
  env           = var.env
  vpc_id        = var.vpc_id
  sha           = var.sha
  desired_count = 5
  certificate   = var.certificate
  domain        = var.domain
  subdomain     = var.domain
}