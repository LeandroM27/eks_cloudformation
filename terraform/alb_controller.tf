data "aws_iam_role" "aws_load_balancer_controller" {
  name = "${var.project_name}-alb-controller-rol-${var.environment}"
}


resource "helm_release" "aws-load-balancer-controller" {
  name = "${var.project_name}-alb-controller-${var.environment}"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "default"
  version    = "1.4.1"

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.eks-cluster.id
  }

  set {
    name  = "image.tag"
    value = "v2.4.2"
  }

  set {
    name  = "serviceAccount.name"
    value = "prueba-eks-alb-controller-sa-dev" // creates service account
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" // passes anotation to sa
    value = data.aws_iam_role.aws_load_balancer_controller.arn
  }

}