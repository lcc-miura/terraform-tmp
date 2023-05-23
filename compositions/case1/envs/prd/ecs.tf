module "ecs" {
  source                    = "../../modules/ecs"
  project                   = var.project
  environment               = var.environment
  vpc_id                    = module.network.vpc_id
  public_subnet_1a__id      = module.network.public_subnet_1a__id
  public_subnet_1c__id      = module.network.public_subnet_1c__id
  private_subnet_1a_mgr__id = module.network.private_subnet_1a_mgr__id
  private_subnet_1c_mgr__id = module.network.private_subnet_1c_mgr__id
}