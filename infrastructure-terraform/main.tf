terraform {
  cloud {
    organization = "Monika-testing-env-projects-github"

    workspaces {
      name = "AWS-DevOps-project"
    }
  }
  
}
# terraform {
#    required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "3.74.3"
#     }
# }
# }
provider "aws" {
  #profile = "default"
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}
#create vpc
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
  name = "vpc-eks-ecr"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
    tags = {
    Terraform = var.Terraform
    Environment = var.Environment
  }
}
#create EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "eks-aws-devops-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access  = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  #vpc_id                   = module.vpc.default_vpc_id
  subnet_ids               = ["subnet-03361571d17e5fad1","subnet-0af089247258210fa","subnet-00026bf700c336550"]

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    instance_type                          = var.eks_instance_type
  }

  self_managed_node_groups = {
    one = {
      name         = "node_pool_gp"
      max_size     = 3
      desired_size = 2     
      }
    }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  tags = {
    Environment = var.Environment
    Terraform   = var.Terraform
  }
}
#create ECR 
module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "ecr-repo-aws-devops_project"
  repository_type = "public"
  tags = {
    Terraform   = var.Terraform
    Environment = var.Environment
  }
  }