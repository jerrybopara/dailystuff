terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "my_vpc" {
  source      = "./modules/vpc/"
  infra_env   = var.infra_env
  vpc_cidr    = var.vpc_cidr
  tenancy     = var.tenancy
  vpc_id      = module.my_vpc.vpc_id
  subnet_cidr = var.subnet_cidr
}

module "ec2_Module" {
  source        = "./modules/ec2"
  count         = var.ec2_count
  instance_name = var.instance_name
  instance_type = var.instance_type
  ami_id        = var.ami_id
  subnet_id     = module.my_vpc.subnet_id
  sg_id         = [module.my_vpc.sg_id]
}

