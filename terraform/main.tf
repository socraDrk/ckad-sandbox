data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  production_availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
}

module "networking" {
  source = "./modules/networking"

  region               = var.region
  environment          = var.environment
  team                 = var.team
  project              = var.project
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.production_availability_zones
  allowed_cidr_blocks  = var.allowed_cidr_blocks
}

module "kubernetes" {
 source = "./modules/kubernetes"

 environment         = var.environment
 private_subnets_ids   = sort(flatten(module.networking.private_subnets_id))
 eks_instances_types = var.eks_instances_types
 eks_max_size = var.eks_max_size
 eks_min_size = var.eks_min_size
 eks_desired_size = var.eks_desired_size
}

resource "aws_ecr_repository" "frontend" {
  name                 = "${var.project}-${var.environment}-frontend"
}

resource "aws_ecr_repository" "backend" {
  name                 = "${var.project}-${var.environment}-backend"
}