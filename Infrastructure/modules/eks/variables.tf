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
