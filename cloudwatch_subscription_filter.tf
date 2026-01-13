resource "aws_cloudwatch_log_subscription_filter" "posts_filter" {
  name            = "${var.project_name}-posts-filter"
  log_group_name  = aws_cloudwatch_log_group.controller_lambda_logs.name
  filter_pattern  = "✅ ORIGINAL_POST"
  destination_arn = aws_lambda_function.processor_lambda.arn
  
  depends_on = [
    aws_lambda_function.controller_lambda,
    aws_lambda_function.processor_lambda,
    aws_lambda_permission.allow_cloudwatch_logs
  ]
}