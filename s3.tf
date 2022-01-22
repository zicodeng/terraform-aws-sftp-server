resource "aws_s3_bucket" "transfer_family_sftp_bucket" {
  bucket = local.s3_bucket_name
  acl    = "private"
}
