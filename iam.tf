resource "aws_iam_role" "transfer_family_s3_role" {
  name        = "transfer-family-s3-role"
  description = "Allow AWS Transfer Family to access S3"

  # Grant Transfer Family service the ability to assume this role.
  # This role can only be used by Transfer Family service, not other services,
  # or only role assumed by Transfer Family service is trusted.
  # https://docs.aws.amazon.com/transfer/latest/userguide/requirements-roles.html
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
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
