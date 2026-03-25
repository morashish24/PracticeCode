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