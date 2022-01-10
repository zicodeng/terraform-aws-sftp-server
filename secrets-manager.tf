# Secret for API_GATEWAY transfer server
resource "aws_secretsmanager_secret" "zicodeng_secret" {
  name = "SFTP/zicodeng"
}

resource "aws_secretsmanager_secret_version" "zicodeng_secret_version" {
  secret_id     = aws_secretsmanager_secret.zicodeng_secret.id
  secret_string = <<-EOF
    {
      "HomeDirectory": "/${local.s3_bucket_name}",
      "Password": "foobar",
      "Role": "${aws_iam_role.transfer_family_s3_role.arn}"
    }
  EOF
}
