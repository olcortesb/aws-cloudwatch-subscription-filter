# AWS CloudWatch Subscription Filter POC

This project implements a POC that uses AWS CloudWatch Subscription Filter to process logs and execute actions based on their content.

## Architecture

1. **API Gateway** → Receives POST requests
2. **Lambda Controller** → Processes POST and always logs
3. **CloudWatch Subscription Filter** → Captures logs with `enable=true` automatically
4. **Lambda Processor** → Processes captured logs and saves to DynamoDB

## Deployment

### 1. Build Lambdas
```bash
./build_lambdas.sh
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Plan deployment
```bash
terraform plan
```

### 4. Apply infrastructure
```bash
terraform apply
```

## Usage

### Send POST request

```bash
# POST that will NOT be processed by the subscription filter
curl -X POST https://your-api-gateway-url/posts \
  -H "Content-Type: application/json" \
  -d '{
    "enable": false,
    "message": "This message will not be processed",
    "data": "some data"
  }'

# POST that WILL be processed by the subscription filter
curl -X POST https://your-api-gateway-url/posts \
  -H "Content-Type: application/json" \
  -d '{
    "enable": true,
    "message": "This message will be processed and saved to DynamoDB",
    "data": "some important data"
  }'

# Example with more fields
curl -X POST https://your-api-gateway-url/posts \
  -H "Content-Type: application/json" \
  -d '{
    "enable": true,
    "user_id": "user123",
    "action": "create_order",
    "order_data": {
      "product_id": "prod456",
      "quantity": 2,
      "price": 29.99
    },
    "timestamp": "2024-01-15T10:30:00Z"
  }'

# POST with user data
curl -X POST https://your-api-gateway-url/posts \
  -H "Content-Type: application/json" \
  -d '{
    "enable": true,
    "event_type": "user_registration",
    "user_data": {
      "email": "user@example.com",
      "name": "John Doe",
      "country": "ES"
    },
    "metadata": {
      "source": "web_app",
      "version": "1.2.3"
    }
  }'

# POST with simulated error
curl -X POST https://your-api-gateway-url/posts \
  -H "Content-Type: application/json" \
  -d '{
    "enable": true,
    "event_type": "error_occurred",
    "error_details": {
      "error_code": "DB_CONNECTION_FAILED",
      "message": "Unable to connect to database",
      "severity": "high"
    },
    "context": {
      "service": "payment_processor",
      "request_id": "req_789xyz"
    }
  }'
```

### Verify results

1. **CloudWatch Logs**: Review Lambda Controller logs
2. **DynamoDB**: Verify that data was saved to the table
3. **CloudWatch Subscription Filters**: Verify that the filter was created

## Project Structure

```
.
├── backend.tf                 # S3 backend configuration
├── main.tf                   # AWS Provider
├── variables.tf              # Project variables
├── iam_roles.tf             # IAM roles and policies
├── dynamodb_table.tf        # DynamoDB table
├── cloudwatch_logs.tf               # Log Groups
├── cloudwatch_subscription_filter.tf # CloudWatch Subscription Filter
├── lambda_functions.tf      # Lambda functions
├── api_gateway.tf           # API Gateway
├── outputs.tf               # Project outputs
├── build_lambdas.sh         # Script to build lambdas
├── src/
│   ├── controller_lambda.py # Lambda Controller code
│   └── processor_lambda.py  # Lambda Processor code
└── README.md               # This file
```

## Cleanup

To destroy all infrastructure:

```bash
terraform destroy
```