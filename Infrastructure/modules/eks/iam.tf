#iam role for EKS cluster

resource "aws_iam_role" "eks_admin" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_principal_arn
        }
      }
    ]
  })
  tags = var.tags
}

#attach AWS Managed policies to the role
resource "aws_iam_role_policy_attachment" "eks_admin_cluster_policy" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}



#IRSA role Jenkins
resource "aws_iam_role" "jenkins_irsa_role" {
  name = "jenkins-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc_provider.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks_oidc_provider.url, "https://", "")}:sub" = "system:serviceaccount:jenkins:jenkins"
            "${replace(aws_iam_openid_connect_provider.eks_oidc_provider.url, "https://", "")}:aud" ="sts.amazonaws.com"
          }
        }
      }
    ]
  })
    tags = var.tags
}


#ECR access policy for jenkins irsa role
resource "aws_iam_policy" "jenkins_ecr_access_policy" {
  name        = "jenkins-ecr-access-policy"
  description = "Policy to allow Jenkins to access ECR repositories"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      }
    ]
  })

}

#Attach AWS managed policies to the jenkins irsa role
resource "aws_iam_role_policy_attachment" "jenkins_irsa_ecr_policy_attachment" {
  role       = aws_iam_role.jenkins_irsa_role.name
  policy_arn = aws_iam_policy.jenkins_ecr_access_policy.arn
}

#Jenkins IAM role for EKS access
resource "aws_iam_role" "jenkins_eks_access_role" {
  name = "jenkins-eks-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_principal_arn
        }
      }
    ]
  })
}

#Attach AWS managed EKS Edit access policy to Jenkins role
resource "aws_iam_policy" "jenkins_eks_access_policy" {
  name        = "jenkins-eks-access-policy"
  description = "Policy to allow Jenkins to access EKS cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_eks_access_policy_attachment" {
  role       = aws_iam_role.jenkins_eks_access_role.name
  policy_arn = aws_iam_policy.jenkins_eks_access_policy.arn
}
