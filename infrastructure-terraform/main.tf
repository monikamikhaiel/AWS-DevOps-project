terraform {
  cloud {
    organization = "Monika-testing-env-projects-github"

    workspaces {
      name = "AWS-DevOps-project"
    }
  }
  
}
terraform {
   required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.20.0"
    }
}
}
provider "aws" {
  region = var.region
}
#create vpc
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"
}
#create EKS
#create ECR 