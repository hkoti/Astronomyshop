instance_types = {
  platform      = "t3.micro" #"t3.medium"
  observability = "t3.micro" #"m5.large"
  jvm           = "t3.micro" #"m5.large"
  managed       = "t3.micro" #"t3.large"
  event         = "t3.micro" #"t3.medium"
  high_perf     = "t3.micro" #"c5.large"
  cicd          = "t3.micro" #"t3.large"
  batch         = "t3.micro" #"t3.small"
}
#AWS free tier eligiblity has changed and only few instance types are eligble for free tier now.

cluster_name = "astronomyshop-dev"

kubernetes_version = "1.33"

region       = "ap-south-1"

role_name             = "eks-cluster-role"

trusted_principal_arn = "arn:aws:iam::561947681032:role/astronomy-bastion"

ssh_key_name = "astronomy-shop-project"