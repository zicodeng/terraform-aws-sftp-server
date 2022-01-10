data "archive_file" "sftp_auth" {
  type        = "zip"
  source_dir  = "./lambda/source/"
  output_path = "./sftp-auth.zip"
}

resource "aws_lambda_function" "transfer_family_lambda" {
  filename         = "./sftp-auth.zip"
  function_name    = "transfer-family-lambda"
  handler          = "index.lambda_handler"
  role             = aws_iam_role.transfer_family_lambda_role.arn
  source_code_hash = data.archive_file.sftp_auth.output_base64sha256
  runtime          = "python3.7"

  environment {
    variables = {
      "SecretsManagerRegion" = local.region
    }
  }
}

resource "aws_lambda_permission" "transfer_family_lambda_permission" {
  statement_id  = "AllowExecutionFromApigateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transfer_family_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.transfer_family_api_gateway_rest_api.execution_arn}/*/*/*"
}
