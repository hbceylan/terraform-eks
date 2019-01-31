# Add outbound rule to security group
resource "aws_security_group" "eks-demo" {
  name        = "eks-demo-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.eks-demo-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "eks-demo"
  }
}

# Add inbound rule to security group
resource "aws_security_group_rule" "eks-demo-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks-demo.id}"
  source_security_group_id = "${aws_security_group.eks-demo-node.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-demo-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.eks-demo.id}"
  to_port           = 443
  type              = "ingress"
}

# Create EKS Control Plane Security Group
resource "aws_security_group" "eks-control-plane-sg" {
    name = "eks-control-plane-sg"
    description = "Cluster communication with worker nodes."

    vpc_id = "${aws_vpc.eks-demo-vpc.id}"

    tags {
        Name = "EKS ControlPlane SG"
    }
}