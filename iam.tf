# Grant Transfer Family service the ability to assume a given role.
# This role can only be used by Transfer Family service, not other services,
# or only role assumed by Transfer Family service is trusted.
# https://docs.aws.amazon.com/transfer/latest/userguide/requirements-roles.html
data "aws_iam_policy_document" "transfer_family_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
    effect = "Allow"
  }
}

# Transfer Family => S3
resource "aws_iam_role" "transfer_family_s3_role" {
  name               = "transfer-family-s3-role"
  description        = "Allow AWS Transfer Family to access S3"
  assume_role_policy = data.aws_iam_policy_document.transfer_family_assume_role_policy_document.json
}

data "aws_iam_policy_document" "transfer_family_s3_policy_document" {
  statement {
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    sid       = "AllowListingOfUserFolder"
    resources = ["arn:aws:s3:::${aws_s3_bucket.sftp_bucket.bucket}"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion"
    ]
    sid       = "HomeDirObjectAccess"
    resources = ["arn:aws:s3:::${aws_s3_bucket.sftp_bucket.bucket}/*"]
    effect    = "Allow"
  }

}

resource "aws_iam_policy" "transfer_family_s3_policy" {
  name        = "transfer-family-s3-policy"
  description = "Determine which S3 bucket can be accessed and what S3 actions can be performed"
  policy      = data.aws_iam_policy_document.transfer_family_s3_policy_document.json
}

resource "aws_iam_role_policy_attachment" "transfer_family_s3_policy_attachment" {
  role       = aws_iam_role.transfer_family_s3_role.name
  policy_arn = aws_iam_policy.transfer_family_s3_policy.arn
}

# Transfer Family => API Gateway
resource "aws_iam_role" "transfer_family_invocation_role" {
  name               = "transfer-family-invocation-role"
  description        = "Allow AWS Transfer to access API Gateway"
  assume_role_policy = data.aws_iam_policy_document.transfer_family_assume_role_policy_document.json
}

data "aws_iam_policy_document" "transfer_family_invocation_policy_document" {
  statement {
    actions   = ["execute-api:Invoke"]
    resources = ["arn:aws:execute-api:${local.region}:${local.account_id}:${aws_api_gateway_rest_api.transfer_family_api_gateway_rest_api.id}/*/GET/*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["apigateway:GET"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "transfer_family_invocation_policy" {
  name   = "transfer-family-invocation-policy"
  policy = data.aws_iam_policy_document.transfer_family_invocation_policy_document.json
}

resource "aws_iam_role_policy_attachment" "transfer_family_invocation_policy_attachment" {
  role       = aws_iam_role.transfer_family_invocation_role.name
  policy_arn = aws_iam_policy.transfer_family_invocation_policy.arn
}

# Lambda => Secrets Manager
resource "aws_iam_role" "transfer_family_lambda_role" {
  name               = "transfer-family-lambda-role"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF
}

# Allow Lambda to upload logs to CloudWatch
resource "aws_iam_role_policy_attachment" "transfer_family_lambda_cloudwatch" {
  role       = aws_iam_role.transfer_family_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow Lambda to retrieve secrets from Secrets Manager
resource "aws_iam_policy" "transfer_family_lambda_secrets_manager_policy" {
  name   = "transfer-family-lambda-secrets-manager-policy"
  policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "secretsmanager:GetSecretValue",
                "Resource": "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:${local.secret_id_prefix}/*"
            }
        ]
    }
  EOF
}

resource "aws_iam_role_policy_attachment" "transfer_family_lambda_secrets_manager_policy_attachment" {
  role       = aws_iam_role.transfer_family_lambda_role.name
  policy_arn = aws_iam_policy.transfer_family_lambda_secrets_manager_policy.arn
}
