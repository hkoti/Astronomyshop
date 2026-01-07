#VPC module 

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.0" #"6.5.1"

  ############################
  # VPC Core
  ############################

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  ############################
  # Networking
  ############################

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  ############################
  # Subnet Tags (CRITICAL)
  ############################

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
    "Environment"                               = var.environment
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
    "Environment"                               = var.environment
  }

  ############################
  # Global Tags
  ############################

  tags = merge(
    {
      Environment = var.environment
      Project     = var.cluster_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
