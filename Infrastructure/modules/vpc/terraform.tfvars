############################
# Global / Environment
############################

region       = "ap-south-1"
environment  = "dev"
cluster_name = "astronomyshop-dev"

############################
# VPC Configuration
############################

vpc_name = "astronomyshop-dev-vpc"
vpc_cidr = "10.0.0.0/16"

############################
# Availability Zones
############################

azs = [
  "ap-south-1a",
  "ap-south-1b",
  "ap-south-1c"
]

############################
# Subnets
############################

# Public subnets (ALB, NAT Gateway)
public_subnets = [
  "10.0.0.0/24",
  "10.0.1.0/24",
  "10.0.2.0/24"
]

# Private subnets (EKS worker nodes)
private_subnets = [
  "10.0.16.0/20",
  "10.0.32.0/20",
  "10.0.48.0/20"
]

############################
# NAT Gateway
############################

enable_nat_gateway = true
single_nat_gateway = true

############################
# DNS
############################

enable_dns_support   = true
enable_dns_hostnames = true

############################
# Tags
############################

tags = {
  Project     = "AstronomyShop"
  Environment = "dev"
  Owner       = "DevOps"
}
