data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.eks_cluster.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks_cluster.certificate_authority[0].data}' '${var.cluster_name}'
USERDATA

}

resource "aws_launch_configuration" "wg_configuration" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.wg_iam_instance_profile.name
  image_id                    = data.aws_ami.eks_worker.id
  instance_type               = "t2.medium"
  name_prefix                 = "terraform-eks"
  security_groups             = [aws_security_group.sg_node.id]
  user_data_base64            = base64encode(local.demo-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wg_autoscaling" {
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.wg_configuration.id
  max_size             = 2
  min_size             = 1
  name                 = "terraform-eks-demo"
  vpc_zone_identifier  = module.vpc.public_subnets

  tag {
    key                 = "Name"
    value               = "terraform-eks-demo"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

