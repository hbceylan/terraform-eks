resource "aws_s3_bucket" "eks-state-store" {
  bucket = "${var.s3_state_store}"
  acl    = "private"
  force_destroy = "true"

  versioning {
    enabled = true
  }
}