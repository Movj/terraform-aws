resource "aws_api_gateway_rest_api" "test_api" {
  name        = "TestAPI"
  description = "This is my API for demonstration purposes"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Resources
## /some-path {GET}
resource "aws_api_gateway_resource" "test_resource" {
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  parent_id   = aws_api_gateway_rest_api.test_api.root_resource_id
  path_part   = "some-path"

}

resource "aws_api_gateway_method" "test_method" {
  rest_api_id   = aws_api_gateway_rest_api.test_api.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = aws_api_gateway_method.test_method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.test_api.id
  resource_id             = aws_api_gateway_resource.test_resource.id
  http_method             = aws_api_gateway_method.test_method.http_method
  integration_http_method = "POST"
  uri                     = var.test_lambda_invoke_arn
  type                    = "AWS"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"

}

resource "aws_lambda_permission" "api_gw_to_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.test_lambda_function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.test_api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration_response" "lambda_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.test_api.id
  resource_id = aws_api_gateway_resource.test_resource.id
  http_method = aws_api_gateway_method.test_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  response_templates = {
    "application/json" = ""
  }
  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

# Deployment
resource "aws_api_gateway_deployment" "test_deployment" {
  rest_api_id = aws_api_gateway_rest_api.test_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.test_resource.id,
      aws_api_gateway_method.test_method.id,
      aws_api_gateway_integration.lambda_integration.id,
    ]))
  }

  depends_on = [aws_api_gateway_integration.lambda_integration]

  lifecycle {
    create_before_destroy = true
  }
}

# Stages
resource "aws_api_gateway_stage" "test_stage" {
  deployment_id = aws_api_gateway_deployment.test_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.test_api.id
  stage_name    = "live"
}

