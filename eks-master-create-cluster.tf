# Create EKS Cluster
resource "aws_eks_cluster" "eks-demo" {
  name     = "${var.cluster_name}"
  role_arn = "${aws_iam_role.eks-demo.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.eks-demo.id}"]
    subnet_ids         = ["${aws_subnet.eks-demo-subnet.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-demo-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-demo-AmazonEKSServicePolicy",
  ]
}