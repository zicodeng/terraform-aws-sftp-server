variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

locals {
  s3_bucket_name = "zicodeng-terraform-aws-sftp-server"
}
