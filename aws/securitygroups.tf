resource "aws_security_group" "sg_aws_cluster" {
  name        = "terraform-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_eks"
  }
}

resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_aws_cluster.id
  source_security_group_id = aws_security_group.sg_node.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_cluster_ingress_workstation_https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_aws_cluster.id
  to_port           = 443
  type              = "ingress"
}

