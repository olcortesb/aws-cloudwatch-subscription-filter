resource "aws_api_gateway_rest_api" "main_api" {
  name        = "${var.project_name}-api"
  description = "API Gateway for CloudWatch Subscription Filter POC"

  tags = {
    Name        = "${var.project_name}-api"
    Environment = var.environment
  }
}

resource "aws_api_gateway_resource" "posts_resource" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id
  parent_id   = aws_api_gateway_rest_api.main_api.root_resource_id
  path_part   = "posts"
}

resource "aws_api_gateway_method" "posts_post" {
  rest_api_id   = aws_api_gateway_rest_api.main_api.id
  resource_id   = aws_api_gateway_resource.posts_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id
  resource_id = aws_api_gateway_resource.posts_resource.id
  http_method = aws_api_gateway_method.posts_post.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.controller_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "main_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.main_api.id
}

resource "aws_api_gateway_stage" "main_stage" {
  deployment_id = aws_api_gateway_deployment.main_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.main_api.id
  stage_name    = var.environment
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.controller_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main_api.execution_arn}/*/*"
}