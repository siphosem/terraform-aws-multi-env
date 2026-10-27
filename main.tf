terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }

  # Bucket and key come from the pipeline: -backend-config=... (see .github/workflows/terraform.yml)
  backend "s3" {
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "terraform-aws-multi-env"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

module "network" {
  source     = "./modules/network"
  name       = "web-${var.environment}"
  cidr       = var.vpc_cidr
  az_count   = var.az_count
  enable_nat = true
}

module "web" {
  source             = "./modules/web"
  name               = "web-${var.environment}"
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  instance_type      = var.instance_type
  min_size           = var.min_size
  max_size           = var.max_size
  desired_capacity   = var.desired_capacity
}
