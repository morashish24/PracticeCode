resource "aws_eks_cluster" "eks" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
    vpc_config {
        subnet_ids = [
        aws_subnet.public_subnet_1.id,
        aws_subnet.public_subnet_2.id
        ]
    }
}

data "aws_eks_cluster" "eks" {
  name = "my-eks-cluster"
}
data "aws_eks_cluster_auth" "eks" {
  name = "my-eks-cluster"
}

provider "kubernetes" {
  host = aws_eks_cluster.eks.endpoint

  cluster_ca_certificate = base64decode(
    aws_eks_cluster.eks.certificate_authority[0].data
  )

  token = data.aws_eks_cluster_auth.eks.token
}