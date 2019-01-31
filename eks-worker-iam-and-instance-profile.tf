# Create Worker Node Role
resource "aws_iam_role" "eks-demo-node" {
  name = "eks-demo-node-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
# Attach Policies to Worker Node Role
resource "aws_iam_role_policy_attachment" "eks-demo-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks-demo-node.name}"
}

resource "aws_iam_role_policy_attachment" "eks-demo-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks-demo-node.name}"
}

resource "aws_iam_role_policy_attachment" "eks-demo-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks-demo-node.name}"
}

# Create Instance Profile
resource "aws_iam_instance_profile" "eks-demo-node" {
  name = "eks-demo-profile"
  role = "${aws_iam_role.eks-demo-node.name}"
}