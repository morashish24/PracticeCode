resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.eks.certificate_authority[0].data
    )
    token = data.aws_eks_cluster_auth.eks.token
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  set = [
   {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
  ]
}