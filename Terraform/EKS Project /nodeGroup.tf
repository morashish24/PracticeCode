resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.node_role.arn

  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.micro"]

  launch_template {
    id      = aws_launch_template.eks_lt.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "eks_lt" {
  name_prefix   = "eks-node-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.medium"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "EKS-Worker-Node"
    }
  }
}