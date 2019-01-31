locals {
    kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks-demo.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks-demo.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster_name}"
      env:
      - name: AWS_PROFILE
        value: "${var.aws_profile}"
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

resource "null_resource" "kubectl_config_set" {
  provisioner "local-exec" {
    command = "terraform output kubeconfig > ~/.kube/config"
  }
}