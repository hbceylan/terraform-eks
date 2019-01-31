#terraform {
#  backend "s3" {}
#}
#
#data "terraform_remote_state" "state" {
#  backend = "s3"
#  config {
#    bucket          = "${var.s3_state_store}"
#    key             = "${var.cluster_name}-state.tfstate"
#    region          = "${var.aws_region}"
#    profile         = "${var.aws_profile}"
#    dynamodb_table  = "${var.dynamodb_table_name}"
#    encrypt         = "true"
#  }
#}


#export TF_aws_bucket=eks-state-store-31012019
#export TF_aws_key=eks-demo-state.tfstate
#export TF_aws_region=us-west-2
#export TF_aws_profile=eks-demo
#export TF_dynamodb_table_name=terraform-state-lock-dynamo
#
#
#terraform init \
#     -backend-config "bucket=$TF_aws_bucket" \
#     -backend-config "key=$TF_aws_key" \
#     -backend-config "region=$TF_aws_region" \
#     -backend-config "profile=$TF_aws_profile" \
#     -backend-config "dynamodb_table=$TF_dynamodb_table_name"

# S3 bucket permission
# https://www.terraform.io/docs/backends/types/s3.html#s3-bucket-permissions