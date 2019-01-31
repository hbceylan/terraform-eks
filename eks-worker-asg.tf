# Choose AMI
data "aws_ami" "eks-worker-demo" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]
  }

  most_recent = true
}

locals {
  eks-demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-demo.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-demo.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

# Create Launch Configuration
resource "aws_launch_configuration" "eks-demo-launch-conf" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.eks-demo-node.name}"
  image_id                    = "${data.aws_ami.eks-worker-demo.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.aws_key_name}"
  name_prefix                 = "${var.cluster_name}"
  security_groups             = ["${aws_security_group.eks-demo-node.id}"]
  user_data_base64            = "${base64encode(local.eks-demo-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "eks-demo-asg" {
  desired_capacity     = 3
  launch_configuration = "${aws_launch_configuration.eks-demo-launch-conf.id}"
  max_size             = 3
  min_size             = 0
  name                 = "${var.cluster_name}"
  vpc_zone_identifier  = ["${aws_subnet.eks-demo-subnet.*.id}"]

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

