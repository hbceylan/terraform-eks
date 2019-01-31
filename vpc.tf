# Create EKS VPC
resource "aws_vpc" "eks-demo-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = "${
    map(
     "Name", "${var.cluster_name}-vpc",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

data "aws_availability_zones" "available" {}
resource "aws_subnet" "eks-demo-subnet" {
  count = 3

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.80.${count.index}.0/24"
  vpc_id            = "${aws_vpc.eks-demo-vpc.id}"

  tags = "${
    map(
     "Name", "${var.cluster_name}-subnet",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "eks-demo-ig" {
  vpc_id = "${aws_vpc.eks-demo-vpc.id}"

  tags {
    Name = "${var.cluster_name}"
  }
}

resource "aws_route_table" "eks-demo-rt" {
  vpc_id = "${aws_vpc.eks-demo-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks-demo-ig.id}"
  }
}

resource "aws_route_table_association" "eks-demo-rt-associate" {
  count = 3

  subnet_id      = "${aws_subnet.eks-demo-subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-demo-rt.id}"
}