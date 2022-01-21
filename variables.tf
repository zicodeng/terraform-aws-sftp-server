variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

locals {
  region           = "us-west-2"
  account_id       = "515107297873"
  s3_bucket_name   = "zicodeng-terraform-aws-sftp-server"
  secret_id_prefix = "terraform-aws-sftp-server"
}
