# Terraform for Creating a Managed SFTP Server Using AWS Transfer Family

Guide: [Enable password authentication for AWS Transfer for SFTP using AWS Secrets Manager](https://aws.amazon.com/blogs/storage/enable-password-authentication-for-aws-transfer-for-sftp-using-aws-secrets-manager/)

Reference: https://github.com/darren-reddick/terraform-aws-transfer/

## Usage

Unset all AWS credential environment variables first to avoid confusion.

```
unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN && unset AWS_DEFAULT_REGION
```

Terraform plan & apply.

```
terraform plan -var-file="creds.tfvars"

terraform apply -var-file="creds.tfvars"
```
