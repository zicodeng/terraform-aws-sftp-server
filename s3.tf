resource "aws_s3_bucket" "sftp_bucket" {
  bucket = local.s3_bucket_name
  acl    = "private"
}
