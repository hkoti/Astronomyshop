variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "trusted_principal_arn" {
  description = "The ARN of the trusted principal that can assume this role"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "instance_types" {
  description = "Instance type per workload-based node group"
  type        = map(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where EKS cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EKS cluster"
  type        = list(string)
}

