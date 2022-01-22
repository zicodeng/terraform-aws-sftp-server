# Secret for API_GATEWAY transfer server
resource "aws_secretsmanager_secret" "transfer_family_sftp_secret_username" {
  name = "${local.secret_id_prefix}/username"
}

resource "aws_secretsmanager_secret_version" "transfer_family_sftp_secret_username_version" {
  secret_id     = aws_secretsmanager_secret.transfer_family_sftp_secret_username.id
  secret_string = "zicodeng"
}

resource "aws_secretsmanager_secret" "transfer_family_sftp_secret_password" {
  name = "${local.secret_id_prefix}/password"
}

resource "aws_secretsmanager_secret_version" "transfer_family_sftp_secret_password_version" {
  secret_id     = aws_secretsmanager_secret.transfer_family_sftp_secret_password.id
  secret_string = "123qwe"
}
