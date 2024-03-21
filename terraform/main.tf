# --------------------------------- providers --------------------------

provider "aws" {
  region = "us-east-1"
}

terraform {

  required_version = ">= 1.3.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
    
  }

  backend "s3" {
    bucket = "agricola-tf-state"
    key    = "tf/state/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "agricola-tf-state"
    encrypt = "true"
  }


}

data "aws_eks_cluster" "eks-cluster" {
  name = "prueba-eks-eks-cluster-dev"
}

provider "helm" { 
  kubernetes {
    host                   = data.aws_eks_cluster.eks-cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks-cluster.id]
      command     = "aws"
    }
  }
}

## creates a file with what is needed to use kubernetes in our cluster

data "aws_eks_cluster_auth" "cluster_kube_config" {
  name = data.aws_eks_cluster.eks-cluster.id // this one needs to change for multi env since it uses cluster as ref
  depends_on = [data.aws_eks_cluster.eks-cluster]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster_kube_config.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority.0.data)
}