resource "aws_cloudwatch_log_group" "controller_lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-controller"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-controller-logs"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "processor_lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-processor"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-processor-logs"
    Environment = var.environment
  }
}