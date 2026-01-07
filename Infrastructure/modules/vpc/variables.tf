############################
# Global / Environment
############################

variable "region" {
  description = "AWS region where the VPC will be created"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, qa, stage, prod)"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name (used for subnet tagging)"
  type        = string
}

############################
# VPC Configuration
############################

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

############################
# Availability Zones
############################

variable "azs" {
  description = "List of availability zones to use"
  type        = list(string)
}

############################
# Subnets
############################

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

############################
# NAT Gateway
############################

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT Gateway (cost optimization)"
  type        = bool
  default     = true
}

############################
# DNS
############################

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

############################
# Tags
############################

variable "tags" {
  description = "Common tags to apply to all VPC resources"
  type        = map(string)
  default     = {}
}
