output "eks_admin_role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.eks_admin.arn
}

output "jenkins_irsa_role_arn" {
  description = "The ARN of the Jenkins IRSA role"
  value       = aws_iam_role.jenkins_irsa_role.arn
}

output "jenkins_eks_access_role_arn" {
    description = "The ARN of the Jenkins EKS access role"
    value       = aws_iam_role.jenkins_eks_access_role.arn
}