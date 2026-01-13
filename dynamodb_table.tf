resource "aws_dynamodb_table" "posts_table" {
  name           = "${var.project_name}-posts"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-posts"
    Environment = var.environment
  }
}