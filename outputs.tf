output "api_gateway_url" {
  description = "URL del API Gateway"
  value       = "${aws_api_gateway_stage.main_stage.invoke_url}/posts"
}

output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.posts_table.name
}

output "controller_lambda_name" {
  description = "Nombre de la Lambda Controller"
  value       = aws_lambda_function.controller_lambda.function_name
}

output "processor_lambda_name" {
  description = "Nombre de la Lambda Processor"
  value       = aws_lambda_function.processor_lambda.function_name
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.controller_lambda_logs.name
}