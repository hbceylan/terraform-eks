resource "kubernetes_config_map" "iam_nodes_config_map" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data {
    mapRoles = <<ROLES
- rolearn: ${aws_iam_role.eks-demo-node.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
ROLES
}
depends_on = [
        "null_resource.kubectl_config_set",
    ]
}