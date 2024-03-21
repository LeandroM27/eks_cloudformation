# data "aws_iam_role" "aws_load_balancer_controller" {
#   name = "prueba-eks-alb-controller-rol-dev"
# }


# resource "helm_release" "aws-load-balancer-controller" {
#   name = "prueba-eks-alb-controller-dev"

#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "default"
#   version    = "1.4.1"

#   set {
#     name  = "clusterName"
#     value = data.aws_eks_cluster.eks-cluster.id
#   }

#   set {
#     name  = "image.tag"
#     value = "v2.4.2"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "prueba-eks-alb-controller-sa-dev" // creates service account
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" // passes anotation to sa
#     value = data.aws_iam_role.aws_load_balancer_controller.arn
#   }

# }

# this is added for a test

data "aws_vpc" "main" {
  id = "prueba-eks-main-dev"
}

resource "aws_security_group" "alb-sg" {
  name   = "alb-sg"
  vpc_id = data.aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}