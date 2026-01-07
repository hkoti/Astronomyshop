############################
# VPC Outputs
############################

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

############################
# Subnet Outputs
############################

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

############################
# Availability Zones
############################

output "azs" {
  description = "Availability zones used by the VPC"
  value       = module.vpc.azs
}
