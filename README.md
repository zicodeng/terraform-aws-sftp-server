# Terraform for Creating a Managed SFTP Server Using AWS Transfer Family

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
