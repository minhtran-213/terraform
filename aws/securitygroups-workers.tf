# workers
resource "aws_security_group" "sg_node" {
  name        = "terraform_eks_node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "terraform_eks_node"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "sg_node_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_node.id
  source_security_group_id = aws_security_group.sg_node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "sg_node_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_node.id
  source_security_group_id = aws_security_group.sg_aws_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

