#EKS module
#Code for eks cluster on AWS using Terraform modules
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"
  
  name = "my-eks-cluster"
  kubernetes_version = "1.33"
  vpc_id = "vpc-xxxxxxxx"
  subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy", "subnet-zzzzzzzz"]
  control_plane_subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy", "subnet-zzzzzzzz"]

  endpoint_private_access = true
  endpoint_public_access = true
  endpoint_public_access_cidrs = [""]

  enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  create_kms_key  = true
  encryption_config = [
    {
      provider_arn = module.eks.kms_key_arn
      resources    = ["secrets"]
    }
  ]
  kms_key_administrators = ["arn:aws:iam::123456789012:role/AdminRole"]

  enable_irsa = true
  openid_connect_audiences = ["sts.amazonaws.com"]
  iam_role_name = "my-eks-cluster-role"
  iam_role_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]

    #Cluster Addons
  addons = [
    {
      name       = "vpc-cni"
      version    = "v1.13.3-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    },
    {
      name       = "kube-proxy"
      version    = "v1.33.7-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    },
    {
      name       = "coredns"
      version    = "v1.10.1-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
  ]
  # Access entries/RBAC
  access_entries = [
    {
      arn  = "arn:aws:iam::123456789012:role/AdminRole"
      groups = ["system:masters"]
    },
    {
      arn  = "arn:aws:iam::123456789012:role/ReadOnlyRole"
      groups = ["system:readers"]
    }
  ]

  #Create Security Group for EKS Cluster
  create_security_group = true
  security_group_name = "my-eks-cluster-sg"
  

  #Observability (cloudwatch)
  cloudwatch_log_group_retention_in_days = 2


  #tags
  cluster_tags = {
    Environment = "dev"
    Project     = "my-eks-project"
  }
  node_security_group_tags = {
    Environment = "dev"
    Project     = "my-eks-project"
  }

  #Self-managed Node Group 
  self_managed_node_groups = {
    platform = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      ami_id =
      ami_type =
      pre_bootstrap_user_data =
        bootstrap_extra_args =

        #IAM & Security
      iam_role_name = 
      iam_role_additional_policies = 
      create_iam_instance_profile = true

      #Node Security Hardening
      metadata_options = {
        http_tokens = "required"
        http_put_response_hop_limit = 2
      }
      enable_monitoring = true
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            delete_on_termination = true
          }
        }
      ]

      #Kubernetes labels and isolation
      labels = {
        role = "platform"
      }
      taints = {
        key    = "role"
        value  = "platform"
        effect = "NoSchedule"
      }
      kubelet_extra_args =

      #network and traffic control
      security_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      associate_public_ip_address = true
        additional_security_group_ids = []
      
      #Obeservability & Cloud operations
      enable_metrics_collection = true
      cloudwatch_log_group_retention_in_days = 7

      #governance & cost management
      tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      launch_template_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      auto_scaling_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }

      instance_type = "t3.medium"

      key_name = "my-key-pair"

      additional_tags = {
        Name = "platform-node-group"
      }
    }

    Observability = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      ami_id =
      ami_type =
      pre_bootstrap_user_data =
        bootstrap_extra_args =

        #IAM & Security
      iam_role_name = 
      iam_role_additional_policies = 
      create_iam_instance_profile = true

      #Node Security Hardening
      metadata_options = {
        http_tokens = "required"
        http_put_response_hop_limit = 2
      }
      enable_monitoring = true
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            delete_on_termination = true
          }
        }
      ]

      #Kubernetes labels and isolation
      labels = {
        role = "platform"
      }
      taints = {
        key    = "role"
        value  = "platform"
        effect = "NoSchedule"
      }
      kubelet_extra_args =

      #network and traffic control
      security_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      associate_public_ip_address = true
        additional_security_group_ids = []
      
      #Obeservability & Cloud operations
      enable_metrics_collection = true
      cloudwatch_log_group_retention_in_days = 7

      #governance & cost management
      tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      launch_template_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      auto_scaling_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }

      instance_type = "t3.medium"

      key_name = "my-key-pair"

      additional_tags = {
        Name = "platform-node-group"
      }

      instance_type = "t3.small"

      key_name = "my-key-pair"

      additional_tags = {
        Name = "observability-node-group"
      }
    }

    jvm = {
      desired_capacity = 2
      max_capacity     = 4
      min_capacity     = 1

      ami_id =
      ami_type =
      pre_bootstrap_user_data =
        bootstrap_extra_args =

        #IAM & Security
      iam_role_name = 
      iam_role_additional_policies = 
      create_iam_instance_profile = true

      #Node Security Hardening
      metadata_options = {
        http_tokens = "required"
        http_put_response_hop_limit = 2
      }
      enable_monitoring = true
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            delete_on_termination = true
          }
        }
      ]

      #Kubernetes labels and isolation
      labels = {
        role = "jvm"
      }
      taints = {
        key    = "role"
        value  = "platform"
        effect = "NoSchedule"
      }
      kubelet_extra_args =

      #network and traffic control
      security_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      associate_public_ip_address = true
        additional_security_group_ids = []
      
      #Obeservability & Cloud operations
      enable_metrics_collection = true
      cloudwatch_log_group_retention_in_days = 7

      #governance & cost management
      tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      launch_template_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      auto_scaling_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }

      instance_type = "t3.medium"

      key_name = "my-key-pair"

      additional_tags = {
        Name = "jvm-node-group"
      }
    }

    managed_runtime = {
      desired_capacity = 3
      max_capacity     = 5
      min_capacity     = 2

      ami_id =
      ami_type =
      pre_bootstrap_user_data =
        bootstrap_extra_args =

        #IAM & Security
      iam_role_name = 
      iam_role_additional_policies = 
      create_iam_instance_profile = true

      #Node Security Hardening
      metadata_options = {
        http_tokens = "required"
        http_put_response_hop_limit = 2
      }
      enable_monitoring = true
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            delete_on_termination = true
          }
        }
      ]

      #Kubernetes labels and isolation
      labels = {
        role = "managed_runtime"
      }
      taints = {
        key    = "role"
        value  = "platform"
        effect = "NoSchedule"
      }
      kubelet_extra_args =

      #network and traffic control
      security_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      associate_public_ip_address = true
        additional_security_group_ids = []
      
      #Obeservability & Cloud operations
      enable_metrics_collection = true
      cloudwatch_log_group_retention_in_days = 7

      #governance & cost management
      tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      launch_template_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      auto_scaling_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }

      instance_type = "t3.medium"

      key_name = "my-key-pair"

      additional_tags = {
        Name = "managed_runtime-node-group"
      }
    }

    event_driven = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      ami_id =
      ami_type =
      pre_bootstrap_user_data =
        bootstrap_extra_args =

        #IAM & Security
      iam_role_name = 
      iam_role_additional_policies = 
      create_iam_instance_profile = true

      #Node Security Hardening
      metadata_options = {
        http_tokens = "required"
        http_put_response_hop_limit = 2
      }
      enable_monitoring = true
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            delete_on_termination = true
          }
        }
      ]

      #Kubernetes labels and isolation
      labels = {
        role = "event_driven"
      }
      taints = {
        key    = "role"
        value  = "platform"
        effect = "NoSchedule"
      }
      kubelet_extra_args =

      #network and traffic control
      security_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      associate_public_ip_address = true
        additional_security_group_ids = []
      
      #Obeservability & Cloud operations
      enable_metrics_collection = true
      cloudwatch_log_group_retention_in_days = 7

      #governance & cost management
      tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      launch_template_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      auto_scaling_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }

      instance_type = "t3.medium"

      key_name = "my-key-pair"

      additional_tags = {
        Name = "event_driven-node-group"
      }
    }

    high_performance = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      ami_id =
      ami_type =
      pre_bootstrap_user_data =
        bootstrap_extra_args =

        #IAM & Security
      iam_role_name = 
      iam_role_additional_policies = 
      create_iam_instance_profile = true

      #Node Security Hardening
      metadata_options = {
        http_tokens = "required"
        http_put_response_hop_limit = 2
      }
      enable_monitoring = true
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            delete_on_termination = true
          }
        }
      ]

      #Kubernetes labels and isolation
      labels = {
        role = "high_performance"
      }
      taints = {
        key    = "role"
        value  = "platform"
        effect = "NoSchedule"
      }
      kubelet_extra_args =

      #network and traffic control
      security_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      associate_public_ip_address = true
        additional_security_group_ids = []
      
      #Obeservability & Cloud operations
      enable_metrics_collection = true
      cloudwatch_log_group_retention_in_days = 7

      #governance & cost management
      tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      launch_template_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      auto_scaling_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }

      instance_type = "t3.medium"

      key_name = "my-key-pair"

      additional_tags = {
        Name = "high_performance-node-group"
      }
    }

    CiCd = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      ami_id =
      ami_type =
      pre_bootstrap_user_data =
        bootstrap_extra_args =

        #IAM & Security
      iam_role_name = 
      iam_role_additional_policies = 
      create_iam_instance_profile = true

      #Node Security Hardening
      metadata_options = {
        http_tokens = "required"
        http_put_response_hop_limit = 2
      }
      enable_monitoring = true
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            delete_on_termination = true
          }
        }
      ]

      #Kubernetes labels and isolation
      labels = {
        role = "CiCd"
      }
      taints = {
        key    = "role"
        value  = "platform"
        effect = "NoSchedule"
      }
      kubelet_extra_args =

      #network and traffic control
      security_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      associate_public_ip_address = true
        additional_security_group_ids = []
      
      #Obeservability & Cloud operations
      enable_metrics_collection = true
      cloudwatch_log_group_retention_in_days = 7

      #governance & cost management
      tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      launch_template_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      auto_scaling_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }

      instance_type = "t3.medium"

      key_name = "my-key-pair"

      additional_tags = {
        Name = "CiCd-node-group"
      }
    }

    batch = {
      desired_capacity = 2
      max_capacity     = 4
      min_capacity     = 1

      ami_id =
      ami_type =
      pre_bootstrap_user_data =
        bootstrap_extra_args =

        #IAM & Security
      iam_role_name = 
      iam_role_additional_policies = 
      create_iam_instance_profile = true

      #Node Security Hardening
      metadata_options = {
        http_tokens = "required"
        http_put_response_hop_limit = 2
      }
      enable_monitoring = true
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            delete_on_termination = true
          }
        }
      ]

      #Kubernetes labels and isolation
      labels = {
        role = "batch"
      }
      taints = {
        key    = "role"
        value  = "platform"
        effect = "NoSchedule"
      }
      kubelet_extra_args =

      #network and traffic control
      security_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      associate_public_ip_address = true
        additional_security_group_ids = []
      
      #Obeservability & Cloud operations
      enable_metrics_collection = true
      cloudwatch_log_group_retention_in_days = 7

      #governance & cost management
      tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      launch_template_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }
      auto_scaling_group_tags = {
        Environment = "dev"
        Project     = "my-eks-project"
      }

      instance_type = "t3.medium"

      key_name = "my-key-pair"

      additional_tags = {
        Name = "batch-node-group"
      }
    }
  }

}

