#Code for eks cluster on AWS using Terraform modules
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"
  
  name = "my-eks-cluster"
  kubernetes_version = "1.33"
  vpc_id = "vpc-xxxxxxxx"
  subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy", "subnet-zzzzzzzz"]
  control_plane_subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy", "subnet-zzzzzzzz"]

  enable_irsa = true

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
      principal_arn  = aws_iam_role.eks_admin.arn
      kubernetes_groups = ["system:masters"]
    },
    {
      principal_arn  = aws_iam_role.jenkins_eks_access_role.arn
      kubernetes_groups = ["jenkins-developers"]
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
    #1- Platform Node Group
    /*
    Workloads : CoreDNS, CNI, kube-proxy, ingress 
    characteristics : stable; low CPU; Predicatable memory  
    */
    platform = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

        #IAM & Security

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
      taints =[
         {
        key    = "role"
        value  = "platform"
        effect = "NO_SCHEDULE"
      }
      ]
      

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

      instance_type = var.instance_types["platform"]


      key_name = var.ssh_key_name

      additional_tags = {
        Name = "platform-node-group"
      }
    }

      #2 - Observability Node Group
    /*
    Workloads : Opentelemetry collector; Metrics/logging agents
    characteristics :   Memory heavy, steady usage, sensitive to OOM
    */

    Observability = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

        #IAM & Security

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
        role = "Observability"
      }
      taints = [
      {
        key    = "role"
        value  = "Observability"
        effect = "NO_SCHEDULE"
      }
      ]
      

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

      instance_type = var.instance_types["observability"]


      key_name = var.ssh_key_name

      additional_tags = {
        Name = "observability-node-group"
      }
    }
 
    #3 - Application Node Groups (JVM)
        /*
    Workloads :  JVM based services (Cart service, Checkout service)
    characteristics : Heap heavy, GC sensitive  
    */
    jvm = {
      desired_capacity = 2
      max_capacity     = 4
      min_capacity     = 1

        #IAM & Security

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
      taints = [
      {
        key    = "role"
        value  = "jvm"
        effect = "NO_SCHEDULE"
      }
      ]
      

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

      instance_type = var.instance_types["jvm"]

      key_name = var.ssh_key_name

      additional_tags = {
        Name = "jvm-node-group"
      }
    }

    #4 - Application Node Groups (Runtime)
    /*
    Workloads : (.NET, PHP, Ruby) based services 
    characteristics : Moderate CPU & Memory; Horizontal scaling  
    */
    managed_runtime = {
      desired_capacity = 3
      max_capacity     = 5
      min_capacity     = 2

        #IAM & Security

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
      taints = [
      {
        key    = "role"
        value  = "managed_runtime"
        effect = "NO_SCHEDULE"
      }
      ]

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

      instance_type = var.instance_types["managed"]


      key_name = var.ssh_key_name

      additional_tags = {
        Name = "managed_runtime-node-group"
      }
    }

    #5 - Additional Node Group (event_driven)
    /*
    Workloads : (Node.js, Python, Elixir) based services 
    characteristics : IO-heavy; lower per pod CPU; Fast scale  
    */
    
    event_driven = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1


        #IAM & Security

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
      taints = [
      {
        key    = "role"
        value  = "event_driven"
        effect = "NO_SCHEDULE"
      }
      ]

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

      instance_type = var.instance_types["event"]


      key_name = var.ssh_key_name

      additional_tags = {
        Name = "event_driven-node-group"
      }
    }

    #6 - Additional Node Group (high_performance)
    /*
    Workloads : (Go, Rust, C++) based services 
    characteristics : CPU bound, low GC, Predictable memory  
    */
    high_performance = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      #IAM & Security
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
      taints =[
         {
        key    = "role"
        value  = "high_performance"
        effect = "NO_SCHEDULE"
      }
      ]
      

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

      instance_type = var.instance_types["high_perf"]

      key_name = var.ssh_key_name

      additional_tags = {
        Name = "high_performance-node-group"
      }
    }

    #7 - Additional Node Group (CiCd)
    /*
    Workloads : Jenkins agents 
    characteristics : Burstable CPU, short lived, Cost effective  
    */
    CiCd = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

        #IAM & Security

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
      taints = [
      {
        key    = "role"
        value  = "CiCd"
        effect = "NO_SCHEDULE"
      }
      ]

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

      instance_type = var.instance_types["cicd"]

      key_name = var.ssh_key_name

      additional_tags = {
        Name = "CiCd-node-group"
      }
    }

    #8 - Additional Node Group (batch)
    /*
    Workloads : (Node.js, Python, Elixir) based services 
    characteristics : mom-critical, interruptible, cost-effective  
    */    
    batch = {
      desired_capacity = 2
      max_capacity     = 4
      min_capacity     = 1

    #IAM & Security

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
        value  = "batch"
        effect = "NO_SCHEDULE"
      }
      

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

      instance_type = var.instance_types["batch"]

      key_name = var.ssh_key_name

      additional_tags = {
        Name = "batch-node-group"
      }
    }
  }
}
