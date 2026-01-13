# Lambda Controller Function
resource "aws_lambda_function" "controller_lambda" {
  filename         = "controller_lambda.zip"
  function_name    = "${var.project_name}-controller"
  role            = aws_iam_role.lambda_controller_role.arn
  handler         = "index.handler"
  runtime         = "python3.9"
  timeout         = 30
  source_code_hash = filebase64sha256("controller_lambda.zip")

  environment {
    variables = {
      PROJECT_NAME = var.project_name
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_controller_policy,
    aws_cloudwatch_log_group.controller_lambda_logs,
  ]

  tags = {
    Name        = "${var.project_name}-controller"
    Environment = var.environment
  }
}

# Lambda Processor Function
resource "aws_lambda_function" "processor_lambda" {
  filename         = "processor_lambda.zip"
  function_name    = "${var.project_name}-processor"
  role            = aws_iam_role.lambda_processor_role.arn
  handler         = "index.handler"
  runtime         = "python3.9"
  timeout         = 30
  source_code_hash = filebase64sha256("processor_lambda.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.posts_table.name
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_processor_policy,
    aws_cloudwatch_log_group.processor_lambda_logs,
  ]

  tags = {
    Name        = "${var.project_name}-processor"
    Environment = var.environment
  }
}

# Lambda Permission for CloudWatch Logs
resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor_lambda.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.controller_lambda_logs.arn}:*"
}