# Secret for API_GATEWAY transfer server
resource "aws_secretsmanager_secret" "secret_username" {
  name = "${local.secret_id_prefix}/username"
}

resource "aws_secretsmanager_secret_version" "secret_username_version" {
  secret_id     = aws_secretsmanager_secret.secret_username.id
  secret_string = "zicodeng"
}

resource "aws_secretsmanager_secret" "secret_password" {
  name = "${local.secret_id_prefix}/password"
}

resource "aws_secretsmanager_secret_version" "secret_password_version" {
  secret_id     = aws_secretsmanager_secret.secret_password.id
  secret_string = "123qwe"
}
