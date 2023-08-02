resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.iam_role_cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.sg_aws_cluster.id]
    subnet_ids         = module.vpc.public_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam_policy_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.iam_policy_AmazonEKSServicePolicy,
  ]
}

