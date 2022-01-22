data "template_file" "transfer_family_idp_api" {
  template = file("./api.yaml")

  vars = {
    LAMBDA_INVOKE_ARN = aws_lambda_function.transfer_family_lambda.invoke_arn
  }
}

resource "aws_api_gateway_rest_api" "transfer_family_api_gateway_rest_api" {
  name        = "transfer-family-api-gateway-rest-api"
  description = "This API provides an IDP (Identity Provider) for AWS Transfer Family"
  body        = data.template_file.transfer_family_idp_api.rendered

  endpoint_configuration {
    types = [
      "REGIONAL",
    ]
  }
}

resource "aws_api_gateway_deployment" "transfer_family_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.transfer_family_api_gateway_rest_api.id
  triggers = {
    redeployment = sha1(jsonencode([aws_api_gateway_rest_api.transfer_family_api_gateway_rest_api.body]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "transfer_family_api_gateway_stage" {
  stage_name    = "main"
  rest_api_id   = aws_api_gateway_rest_api.transfer_family_api_gateway_rest_api.id
  deployment_id = aws_api_gateway_deployment.transfer_family_api_gateway_deployment.id
}


